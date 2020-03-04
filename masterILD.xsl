<?xml version="1.0" encoding="UTF-8" ?>

<!-- New XSLT document created with EditiX XML Editor (http://www.editix.com) at Mon Mar 02 08:29:52 CET 2020 -->

<!-- penser à xsl include pour ne pas surcharger feuille principale -->

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
	xmlns:err="http://www.w3.org/2005/xqt-errors"
	exclude-result-prefixes="xs xdt err fn">

	<xsl:output
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    method="html"/>
	
	<xsl:template match="/">
		
		<html><body>
      		<xsl:call-template name="liste-des-enseignants" />
      		<xsl:call-template name="liste-des-unites" />
			<xsl:call-template name="liste-des-parcours" />

      		<a href="masterILD.html#Rem"> Lien vers Remi Morin </a>
      		<a href="masterILD.html#JL"> Lien vers Jean-Luc Massat </a>
    		</body></html>

		<xsl:result-document href="foo.html">
			<!-- add instructions to generate document content here -->
		</xsl:result-document>

		</xsl:template>
		
	<xsl:template name="liste-des-enseignants">
    		<h1>Liste intervenant</h1>
    		<o1> <xsl:apply-templates select="//listeIntervenants" /> </o1>
  	</xsl:template>

  	<xsl:template match="intervenant">
		<xsl:variable name="name" select="./nom"> </xsl:variable>
		<xsl:variable name="identif" select="@id"> </xsl:variable>
		<li>
			<xsl:value-of select="$name" />
		</li>

		<xsl:result-document href = "www/intervenants/{$name}.html" >
			<html>
				<body>
					<o1>
						<li> <xsl:value-of select="$name" /> </li>
						<li> <xsl:value-of select="./mail" /> </li>
						<li> <xsl:value-of select="./site" /> </li>
					</o1>
					<h3> Liens vers les UEs assurés par l'enseignant : </h3>
					<ul>
					<xsl:for-each select='/descendant::bloc/ue/refintervenant[@ref= $identif]/../nom'>
						<xsl:variable name="ue" select="."> </xsl:variable>
						<li> <a href="../UEs/{$ue}.html"> <xsl:value-of select="."/> </a> </li>
					</xsl:for-each>
					</ul>
				</body>
			</html>

		</xsl:result-document>

  		</xsl:template>

  	<xsl:template name="liste-des-unites">
		<!-- nom, identifiant, nbcredit, resume?, plan?, lieu?, refintervenant -->

		<h1>Liste des ues </h1>
		<xsl:for-each select="/descendant::ue">
			<xsl:variable name="name" select="./nom"> </xsl:variable>
			<xsl:result-document href = "www/UEs/{$name}.html" >
			<html>
				<body>
						<o1>
							<li> <xsl:value-of select="nom" /> </li>
							<li> <xsl:value-of select="identifiant" /> </li>
							<li> <xsl:value-of select="nbcredit" /> </li>
							<li> <xsl:value-of select="lieu" /> </li>
							<li> <xsl:value-of select="refintervenant" /> </li>
						</o1>
				</body>
			</html>
			</xsl:result-document>
		</xsl:for-each>
  	</xsl:template>

	<xsl:template name="liste-des-parcours">
		<!-- nom, listeResponsables, description, listeDebouches,ref-semestre+ -->
		<xsl:for-each select="//parcours">
			<xsl:variable name="name" select="./nom"> </xsl:variable>
			<xsl:result-document href = "www/parcours/{$name}.html" >
				<html>
					<body>
						<h1> <xsl:value-of select="nom" /> </h1>
						<h2> Les responsables du master sont : </h2>
						<ol>
						<xsl:for-each select="./listeResponsables/responsable">
							<li> <xsl:value-of select="."></xsl:value-of> </li>
						</xsl:for-each>
						</ol>

						<h2> Description du parcours : </h2>
						<!-- Avoir recours à la substitution = créer template spéciale OU pleins de matchl? -->
						<xsl:apply-templates select="description" />
					</body>
				</html>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="paragraphe">
		<p> <xsl:value-of select="."/> </p>
	</xsl:template>

	<xsl:template match="liste-pucee">
		<ol>
		<xsl:for-each select="paragraphe">
			<li> <p> <xsl:apply-templates/> </p> </li>
		</xsl:for-each>
		</ol>
	</xsl:template>

	<xsl:template match="gras">
		<b> <xsl:value-of select="."/> </b>
	</xsl:template>

	<xsl:template match="italique">
		<i> <xsl:value-of select="."/> </i>
	</xsl:template>

	<xsl:template match="link">
		<xsl:variable name="url" select="."/>
		<a href="{$url}"> <xsl:value-of select="."/> </a>
	</xsl:template>




</xsl:stylesheet>



  






