<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:err="http://www.w3.org/2005/xqt-errors"
                exclude-result-prefixes="xs xdt err fn">

    <xsl:template name="listesUesEtEnseignants">

        <xsl:result-document href="www/intervenants/liste_Intervenants.html">
            <html>
                <meta charset="UTF-8"/>
                <body>
                    <xsl:call-template name="menuStatique"/>
                    <h1>Liste des intervenants du master Info</h1>
                    <ol>
                    <xsl:for-each select="//listeIntervenants/intervenant">
                        <xsl:variable name="name" select="./nom"></xsl:variable>
                        <li>
                            <a href="../intervenants/{$name}.html"> <xsl:value-of select="$name"/> </a>
                        </li>
                    </xsl:for-each>
                    </ol>
                </body>
            </html>
        </xsl:result-document>

        <xsl:result-document href="www/UEs/liste_UEs.html">
            <html>
                <meta charset="UTF-8"/>
                <body>
                    <xsl:call-template name="menuStatique"/>
                    <h1>Liste des UEs du master Info</h1>
                    <ol>
                        <xsl:for-each select="//descendant::ue">
                            <xsl:variable name="name" select="./nom"></xsl:variable>
                            <li>
                                <a href="../UEs/{$name}.html"> <xsl:value-of select="$name"/> </a>
                            </li>
                        </xsl:for-each>
                    </ol>
                </body>
            </html>
        </xsl:result-document>

    </xsl:template>

    <xsl:template name="menuStatique">
        <h1> Menu </h1>
        <ul id="menu">
            <li><a href="../Accueil/accueil.html"> Accueil </a></li>
            <li><a href="../UEs/liste_UEs.html"> liste des UEs </a></li>
            <li><a href="../intervenants/liste_Intervenants.html"> liste des intervenants </a></li>
        </ul>
    </xsl:template>

    <!-- Cette template prendra un paramètre : la ref du semestre-->
    <xsl:template name="liste-ues-du-semestre">
        <xsl:param name="refSemestre"/>
        <h3>Semestre : <xsl:value-of select="/descendant::semestre[@id=$refSemestre]/@id"/> </h3>
        <ol>
        <xsl:for-each select="/descendant::semestre[@id=$refSemestre]/bloc/ue">
        <xsl:variable name="ueName" select="nom"/>
        <li> <a href="../UEs/{$ueName}.html"> <xsl:value-of select="$ueName"/> </a> </li>
        </xsl:for-each>
        </ol>

    </xsl:template>

</xsl:stylesheet>