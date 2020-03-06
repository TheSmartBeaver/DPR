web: 
	rm -rf www	
	mkdir -p www/Accueil
	java -jar saxon9he.jar -xsl:xsl/master.xsl master.xml > www/Accueil/accueil.html

#tidy -im -asxhtml -indent www/parcours/*.html
#tidy -im -asxhtml -indent www/intervenants/*.html
#tidy -im -asxhtml -indent www/Accueil/*.html
#tidy -im -asxhtml -indent www/UEs/*.html
tidy:
	tidy -im -asxhtml -indent www/*/*.html

dtd:
	xmllint --noout --dtdvalid master.dtd master.xml

xsd:
	xmllint --schema master.xsd master.xml --noout

xq:
	java -cp saxon9he.jar net.sf.saxon.Query xq.xql -o:www/xq.html

all: dtd xsd web
	sleep 2
	tidy -im -asxhtml -indent www/*/*.html
	sleep 1
	java -cp saxon9he.jar net.sf.saxon.Query xq.xql -o:www/xq.html

