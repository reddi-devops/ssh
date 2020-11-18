# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export JAVA_HOME=/opt/jdk1.8.0_271/
PATH=$PATH:$HOME/.local/bin:$HOME/bin:/opt/jdk1.8.0_271/bin:/opt/mvn/bin

export PATH
