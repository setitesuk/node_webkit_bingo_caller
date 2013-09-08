NW    := node-webkit-v0.7.2
NWWIN := $(NW)-win-ia32
NWMAC := $(NW)-osx-ia32

deps:
	touch tmp
	rm -rf tmp node_modules
	mkdir tmp
	rm -rf tmp
	npm install ejs
	cp ejs.js node_modules/ejs/lib/

# I downloaded zip.exe & unzip.exe from http://stahlworks.com/dev/?tool=zipunzip
win:
	if exist dist\win rmdir dist\win /s /q
	if exist tmp rmdir tmp /s /q
	zip -r bingocaller.nw bingocaller package.json node_modules
	mkdir dist\win tmp
	unzip -d tmp -o src\$(NWWIN).zip
	copy /b tmp\nw.exe+bingocaller.nw dist\win\bingocaller.exe
	copy tmp\icudt.dll dist\win
	copy tmp\nw.pak dist\win
	if exist bingocaller.nw del bingocaller.nw /q
	if exist tmp rmdir tmp /q /s

# winico reshacker isn't quite working. should be combined with "win" target
winico:
	"C:\Program Files (x86)\Resource Hacker\ResHacker.exe" -addoverwrite dist\win\bingocaller.exe new.exe resources\bingocaller72x72.ico, ico, 1033

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
