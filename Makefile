dtd:
	xmllint --noout --dtdvalid master.dtd master.xml
xsd:
	xmllint --schema master.xsd master.xml --noout
web: 
	rm -rf www	
	mkdir -p www/Accueil
	java -jar saxon9he.jar -xsl:xsl/master.xsl master.xml > www/Accueil/accueil.html
tidy:
	tidy -im -asxhtml -indent www/*/*.html
xq:
	java -cp saxon9he.jar net.sf.saxon.Query xq.xql -o:www/xq.html

all: dtd xsd web tidy xq
	
