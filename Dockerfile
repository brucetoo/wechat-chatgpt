FROM node:19 AS app

# We don't need the standalone Chromium
# Linux系统上安装Google Chrome浏览器
# 安装了Google Chrome浏览器、Chromium浏览器和Xvfb虚拟桌面服务器
RUN apt-get install -y wget \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get -y install google-chrome-stable chromium  xvfb\
    && rm -rf /var/lib/apt/lists/* \
    && echo "Chrome: " && google-chrome --version
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# xvfb-run 是一个命令行工具，用于在虚拟的 X 服务器环境中运行指定的 X 客户端或命令。它的作用是为应用程序提供一个虚拟的 X 服务器，
# 使得应用程序可以在没有实际 X 服务器的机器上运行。xvfb-run 的主要功能是通过创建一个 Xvfb（X Virtual Framebuffer）进程来模拟一个 X 服务器环境。
# 它会设置 X 授权文件（或使用现有的用户指定的），生成一个 cookie（用于身份验证），然后启动 Xvfb 作为后台进程。
# 然后，指定的命令会在这个虚拟的 X 服务器上运行，并显示相应的 Xvfb 服务器的输出
CMD xvfb-run --server-args="-screen 0 1280x800x24 -ac -nolisten tcp -dpi 96 +extension RANDR" npm run dev