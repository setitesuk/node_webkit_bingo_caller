NW    := node-webkit-v0.7.2
NWWIN := $(NW)-win-ia32
NWMAC := $(NW)-osx-ia32
NWLIN := $(NW)-linux-x64
CYGWIN := c:\cygwin64

deps:
	touch tmp
	rm -rf tmp node_modules
	mkdir tmp
	rm -rf tmp
	npm install ejs
	cp ejs.js node_modules/ejs/lib/

# I downloaded zip.exe & unzip.exe from http://stahlworks.com/dev/?tool=zipunzip
win:
	if exist bingocaller.nw del bingocaller.nw /q
	if exist dist\win rmdir dist\win /s /q
	if exist tmp rmdir tmp /s /q
	dist\tools\zip -r bingocaller.nw bingocaller package.json node_modules
	mkdir dist\win tmp
	dist\tools\unzip -d tmp -o src\$(NWWIN).zip
	dist\tools\Resourcer -op:del -src:tmp\nw.exe -type:14 -name:IDR_MAINFRAME
	dist\tools\Resourcer -op:add -src:tmp\nw.exe -type:14 -name:IDR_MAINFRAME -file:bingocaller72x72.ico -lang:1033
	copy /b tmp\nw.exe+bingocaller.nw dist\win\bingocaller.exe
	copy tmp\icudt.dll dist\win
	copy tmp\nw.pak dist\win
	if exist bingocaller.nw del bingocaller.nw /q
	if exist tmp rmdir tmp /q /s
#	dist\tools\makensis dist\tools\Metrichor_install.nsi

mac:
	[ ! -f bingocaller.nw ] || rm bingocaller.nw
	zip -r bingocaller.nw bingocaller package.json resources/bingocaller72x72.png node_modules
	touch node-webkit.app
	rm -rf node-webkit.app dist/bingocaller.app dist/mac
	mkdir dist/mac
	unzip -o src/$(NWMAC).zip
	mv node-webkit.app dist/mac/bingocaller.app
	mv bingocaller.nw dist/mac/bingocaller.app/Contents/Resources/app.nw
	rm dist/mac/bingocaller.app/Contents/Resources/nw.icns
	sips -s format icns resources/bingocaller512x512.png --out dist/mac/bingocaller.app/Contents/Resources/bingocaller.icns
	perl -i -pe 's{nw[.]icns}{bingocaller.icns}smxg' dist/mac/bingocaller.app/Contents/Info.plist
	perl -i -pe 's{node[-]webkit[ ]App}{Bingo Caller}smxg' dist/mac/bingocaller.app/Contents/Info.plist
