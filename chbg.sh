if [ ! -z "$1" -a -f "$1" ] 
then
	ln -f -L $1 $HOME/.config/background
	i3-msg restart
else
	echo "Please provide a path to your desired background."
fi

