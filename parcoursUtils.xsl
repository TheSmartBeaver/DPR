<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:err="http://www.w3.org/2005/xqt-errors"
                exclude-result-prefixes="xs xdt err fn">

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