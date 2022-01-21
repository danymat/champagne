# Champagne 🥂

## Installation

```
{
    git clone https://github.com/NvChad/NvChad ~/.config/nvim
    nvim -c "autocmd User PackerComplete quitall" -c "PackerSync"
    nvim
}
```

Want to try out on a small docker container before deciding ?

```
docker run -w /root -it --rm alpine:edge sh -uelic '
    apk add git nodejs neovim ripgrep alpine-sdk --update
    git clone https://github.com/danymat/champagne ~/.config/nvim
    nvim -c "autocmd User PackerComplete quitall" -c "PackerSync"
    nvim
    '
```

## Update

```
git -C ~/.config/nvim/ fetch
```
