# Скачать последнюю версию
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

# Распаковать
tar -xzf nvim-linux-x86_64.tar.gz

# Переместить (нужен sudo)
mv nvim-linux-x86_64 /opt/nvim

# Добавить в PATH
echo 'export PATH="/opt/nvim/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc