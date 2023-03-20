"""

Ubuntu Setup Script + TutorCruncher Setup

Last configured for 22.10 on 20/03/2023

Ensure you are runing this command from your home directory 

"""





# User Prompts
read -p "Enter your name: " name
read -p "Enter your GitHub username: " github_username
read -p "Enter your GitHub email: " github_email
echo "Enter 1 for first-time setup or 2 for reinstallation"
read -p "Choice: " choice

# Dependencies
sudo apt update
sudo apt install -y \
build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
sudo apt-get install python3.9 pip libjpeg-dev libmemcached-dev postgresql-client postgresql postgresql-contrib redis-server libfreetype6-dev libffi-dev
sudo apt-get install postgresql-server-dev-all
sudo apt-get install python3.9-distutils python3-setuptools python3.9-dev build-essential
sudo apt install curl
sudo apt-get install python3-requests
sudo apt install nautilus-admin

# nodejs, npm and yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
sudo npm cache clean -f
sudo npm install -g n
sudo n 14 

# Tools
sudo apt install -y git curl

# Python
curl https://pyenv.run | bash
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install 3.9
sudo apt install python3-pip
pyenv global 3.9

# Redis
sudo snap install redis

# Postgresql
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt -y install postgresql-15 postgresql-server-dev-15

# Google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

# Other programs
snap install sublime-text --classic
sudo apt install peek
sudo snap install micro --classic
sudo snap install spotify
sudo snap install heroku --classic
sudo snap install pycharm-professional --classic
sudo snap install slack --classic
sudo pip3 install virtualenv awscli devtools
sudo apt install gh xclip
sudo apt-get install autokey-gtk
sudo snap install postman
nautilus -q

# Yarn/NPM
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn npm -y

# Generate RSA key
ssh-keygen -t rsa -b 4096 -C "$github_email"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub
echo "RSA key copied to clipboard. Paste into https://github.com/settings/keys then press a key to continue (dft, press enter twice)"
read -n 1 -s

# Clone repos

git clone git@github.com:tomhamiltonstubber/setup repos
git clone git@github.com:tutorcruncher/tutorcruncher.com  repos/tutorcruncher.com

if [ $choice -eq 1 ]; then
	git clone git@github.com:$github_username/TutorCruncher2 repos/TutorCruncher2
else
	git clone git@github.com:tutorcruncher/TutorCruncher2 repos/TutorCruncher2


# TC Setup

virtualenv -p python3 env
source env/bin/activate
make install-dev
yarn
grablib

make reset-db
python manage.py reset_database --create-demo-agency

python manage.py collectstatic

# Update .bashrc with custom files

echo -e "\nif [ -f ~/repos/.bash_custom ]; then\n  . ~/repos/.bash_custom\nfi" >> .bashrc

# Add .gitconfig file

touch ".gitconfig"
echo -e "[user]\n\tname = $name\n\temail = $github_email\n[include]\n\tpath = ~/repos/.git_custom" >> .gitconfig
