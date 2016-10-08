
Install wxmac 2.9 with python bindings
```
brew install wxmac --python
```

tap robotastic keg
```
brew tap robotastic/homebrew-hackrf
```

install gnuradio
```
brew install gnuradio --with-qt
```

start jack service
```
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

install hackrf
```
brew install hackrf
```

plug in hackrf via usb and test that it works
```
hackrf_info
```

install some dependencies that allows the hackrf to connect to gnuradio companion
```
brew install rtlsdr gr-osmosdr gr-baz --HEAD
```

install gqrx
```
brew install gqrx
```

run gqrx
```
gqrx
```

osmocom_fft -a hackrf