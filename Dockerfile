# Use a newer base image
FROM jlesage/baseimage-gui:debian-12

MAINTAINER Poseidon's 3 Rings

ENV APP_NAME="P3R Brave Browser"
ENV KEEP_APP_RUNNING=1
ENV ENABLE_CJK_FONT=1

# Set UTF-8 locale correctly
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US.UTF-8

WORKDIR /usr/src/P3R

# Copy startup script
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Install required dependencies and Brave Browser
RUN apt-get update && apt-get -y install \
    apt-transport-https \
    curl \
    gnupg \
    fonts-takao-mincho \
    && curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
       https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
       https://brave-browser-apt-release.s3.brave.com/ stable main" \
       | tee /etc/apt/sources.list.d/brave-browser-release.list \
    && apt-get update \
    && apt-get -y install brave-browser \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up Brave browser icon (optional, can be removed if not needed)
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/P3R-CO/unraid/master/Brave-P3R-256px.png && \
    APP_ICON_DESC='{"masterPicture":"/opt/novnc/images/icons/master_icon.png","iconsPath":"/images/icons/","design":{"ios":{"pictureAspect":"noChange","assets":{"ios6AndPriorIcons":false,"ios7AndLaterIcons":false,"precomposedIcons":false,"declareOnlyDefaultIcon":true}},"desktopBrowser":{"design":"raw"},"windows":{"pictureAspect":"noChange","backgroundColor":"#da532c","onConflict":"override","assets":{"windows80Ie10Tile":false,"windows10Ie11EdgeTiles":{"small":false,"medium":true,"big":false,"rectangle":false}}},"androidChrome":{"pictureAspect":"noChange","themeColor":"#ffffff","manifest":{"display":"standalone","orientation":"notSet","onConflict":"override","declared":true},"assets":{"legacyIcon":false,"lowResolutionIcons":false}},"safariPinnedTab":{"pictureAspect":"silhouette","themeColor":"#5bbad5"}},"settings":{"scalingAlgorithm":"Mitchell","errorOnImageTooSmall":false,"readmeFile":false,"htmlCodeFile":false,"usePathAsIs":false},"versioning":{"paramName":"v","paramValue":"ICON_VERSION"}}' && \
    install_app_icon.sh "$APP_ICON_URL" "$APP_ICON_DESC"
