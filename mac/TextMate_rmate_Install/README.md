# TextMate on OS X 10.8.4

October 9, 2013 | git.sbamin.com

## Screenshot

![textmate](https://raw.github.com/textmate/textmate/gh-pages/images/screenshot.png)

# Building

## For OS X 10.8.4:

Original & recommended README for updates (if any): <https://github.com/textmate/textmate>  

### Install pre-requisites:
`brew install ragel boost multimarkdown hg ninja proctools`

### Install Clang 3.2 and capnp:  
Reference & update, if any: <http://kentonv.github.io/capnproto/install.html>  

```
curl -O http://llvm.org/releases/3.2/clang+llvm-3.2-x86_64-apple-darwin11.tar.gz
tar zxf clang+llvm-3.2-x86_64-apple-darwin11.tar.gz
mv clang+llvm-3.2-x86_64-apple-darwin11 ~/apps/clang-3.2

ln -s /usr/lib/c++ ~/apps/clang-3.2/lib/c++
ln -s /usr/lib/arc ~/apps/clang-3.2/lib/arc

mkdir -p ~/apps && cd ~/apps
git clone https://github.com/kentonv/capnproto.git
cd capnproto/c++
./setup-autotools.sh
autoreconf -i
./configure CXX=$HOME/apps/clang-3.2/bin/clang++
make -j6 check
sudo make install
```

### Install TextMate:
```
cd apps
git clone https://github.com/textmate/textmate.git
cd textmate
git submodule update --init
CC=$HOME/apps/clang-3.2/bin/clang CXX=$HOME/apps/clang-3.2/bin/clang++ ./configure
ninja
```

Upon successful install, TextMate application will open. Close TextMate and move TextMate.app to `Applications` directory.

`mv ~/build/TextMate/Applications/TextMate /Applications/`

***

## enable rmate support:

Use TextMate to edit files hosted on remote server via ssh.  

Reference and updates, if any: <https://github.com/textmate/rmate>  

### On Local Mac:  

1. Open TextMate app and go to `Preferences > Terminal` options.
2. Install `mate` script. Export `mate` as default editor in `~/.bashrc` or `~/.profile` (Optional).
3. Enable `rmate` support by checkig `Accept rmate connections` and keeping default `local clients`.
4. Keep default port or change it as required (optional).
5. **Keep TextMate running.**

#### Install RVM and Ruby, if missing:    

Check existing installation, if any.  
`rvm -v`

Download and install official RVM GUI for OS X from <http://jewelrybox.unfiniti.com>  

### On a remote server:

`ssh remote-server`

#### Install RVM and Ruby as pre-requisite if missing:  

`rvm -v`

References:  
1. [On Ubuntu](https://www.digitalocean.com/community/articles/how-to-install-ruby-on-rails-on-ubuntu-12-04-lts-precise-pangolin-with-rvm)  
2. [CentOS 6](https://www.digitalocean.com/community/articles/how-to-install-ruby-on-rails-on-centos-6-with-rvm)  

For Ubuntu 12.04 LTS & CentOS 6:  

```
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm requirements
rvm install ruby
rvm use ruby --default
`rvm rubygems current` #Optional
```

`rvm -v`
>rvm 1.22.18 (stable) by Wayne E. Seguin <wayneeseguin@gmail.com>, Michal Papis <mpapis@gmail.com> [https://rvm.io/].

```
mkdir -p ~/bin
curl -Lo ~/bin/rmate https://raw.github.com/textmate/rmate/master/bin/rmate
chmod a+x ~/bin/rmate
```

>if ~/bin is not in `PATH`, then export PATH in `~/.profile` or `~/.bashrc`.  
`export PATH="$PATH:$HOME/bin"`

`exit`

### On a local mac OS X:

Make sure that TextMate is running in background.  
`ssh -R 52698:localhost:52698 user@remote-server` # 127.0.0.1 instead of localhost may return an error.   
`[user@remote-server ~]$ rmate test.txt`
> This will create/edit remote file, `test.txt` in TextMate.
> Port forwarding can also be achieved using `~/.ssh/config` file. Details and other `rmate` features at <http://blog.macromates.com/2011/mate-and-rmate/>  

***

