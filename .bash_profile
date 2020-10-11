# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export JAVA_HOME=/opt/jdk1.8.0_241/
PATH=$PATH:$HOME/.local/bin:$HOME/bin:/opt/jdk1.8.0_241/bin/

export PATH
