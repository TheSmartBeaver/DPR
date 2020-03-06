<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
                xmlns:err="http://www.w3.org/2005/xqt-errors"
                exclude-result-prefixes="xs xdt err fn">

<!-- Templates match nécessaires pour la page de présentation du parcours, pour la description -->

<xsl:template match="paragraphe">
    <p>
        <xsl:apply-templates/>
    </p>
</xsl:template>

<xsl:template match="liste-pucee">
<ol>
    <xsl:for-each select="paragraphe">
        <li>
            <p>
                <xsl:apply-templates/>
            </p>
        </li>
    </xsl:for-each>
</ol>
</xsl:template>

<xsl:template match="gras">
<b>
    <xsl:value-of select="."/>
</b>
</xsl:template>

<xsl:template match="italique">
<i>
    <xsl:value-of select="."/>
</i>
</xsl:template>

<xsl:template match="link">
<xsl:variable name="url" select="."/>
<a href="{$url}">
    <xsl:value-of select="."/>
</a>
</xsl:template>

<xsl:template match="tab">
<table>
    <xsl:for-each select="tabLine">
        <tr>
            <xsl:for-each select="tab-element">
                <td>
                    <xsl:value-of select="."/>
                </td>
            </xsl:for-each>
        </tr>
    </xsl:for-each>
</table>
</xsl:template>
</xsl:stylesheet>