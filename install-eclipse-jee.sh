
URL=$(printf "https://eclipse.c3sl.ufpr.br%s" $(curl -s https://www.eclipse.org/downloads/packages/ | grep "jee" | grep "gtk-x86_64" | cut -d"'" -f2 | cut -d'=' -f2))
