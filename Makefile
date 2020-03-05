web: 
	rm -rf www	
	mkdir -p www/Accueil
	java -jar saxon9he.jar -xsl:masterILD.xsl masterILD.xml > www/Accueil/accueil.html

#tidy -im -asxhtml -indent www/parcours/*.html
#tidy -im -asxhtml -indent www/intervenants/*.html
#tidy -im -asxhtml -indent www/Accueil/*.html
#tidy -im -asxhtml -indent www/UEs/*.html
tidy:
	tidy -im -asxhtml -indent www/*/*.html

dtd:
	xmllint --noout --dtdvalid masterILD.dtd masterILD.xml

xsd:
	xmllint --schema masterILD.xsd masterILD.xml --noout

xq:
	java -cp saxon9he.jar net.sf.saxon.Query testXQuery.xql -o:www/xq.html

all: dtd xsd web tidy xq
