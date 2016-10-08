
```
brew install gnuradio

brew services start jack
```

to install gnuradio python module
```
  mkdir -p /Users/joegallo/.local/lib/python2.7/site-packages
  echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> /Users/joegallo/.local/lib/python2.7/site-packages/homebrew.pth
```

test gnuradio python module
```
  python -c 'import gnuradio'
```
  
test gnucompanion
```
  gnuradio-companion
```
