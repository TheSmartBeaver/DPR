web: 
	java -jar saxon9he.jar -xsl:masterILD.xsl masterILD.xml

tidy:
	tidy -im -asxhtml -indent BLABLABLA

dtd:
	xmllint --noout --dtdvalid masterILD.dtd masterILD.xml

xsd:
	xmllint --schema masterILD.xsd masterILD.xml --noout
