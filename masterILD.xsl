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

    <xsl:include href="parcoursUtils.xsl"/>

    <xsl:output
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
            method="html"/>

    <xsl:template match="/">
        <meta charset="iso-8859-1"/>
        <html>
            <body>
                <xsl:call-template name="menuStatique"/>
                <xsl:call-template name="liste-des-enseignants"/>
                <xsl:call-template name="liste-des-unites"/>
                <xsl:call-template name="liste-des-parcours"/>
                <xsl:call-template name="listesUesEtEnseignants"/>
            </body>
        </html>

    </xsl:template>

    <xsl:template name="liste-des-enseignants">
        <h1>Liste intervenant</h1>
        <o1>
            <xsl:apply-templates select="//listeIntervenants"/>
        </o1>
    </xsl:template>

    <!--Permet de retrouver UE facilement à partir ID des enseignants-->
    <xsl:key name="getUeDeEnseignant" match="ue" use="refintervenant/@ref"/>

    <xsl:template match="intervenant">
        <xsl:variable name="name" select="./nom"></xsl:variable>
        <xsl:variable name="identif" select="@id"></xsl:variable>
        <li>
            <xsl:value-of select="$name"/>
        </li>

        <xsl:result-document href="www/intervenants/{$name}.html">
            <html>
                <meta charset="iso-8859-1"/>
                <body>
                    <xsl:call-template name="menuStatique"/>
                    <o1>
                        <li>
                            <h2>
                                <xsl:value-of select="$name"/>
                            </h2>
                        </li>
                        <li>
                            <xsl:value-of select="./mail"/>
                        </li>
                        <li>
                            <xsl:value-of select="./site"/>
                        </li>
                    </o1>
                    <h3>Liens vers les UEs assurés par l'enseignant :</h3>
                    <ul>
                        <!-- Utilisation d'un xsl:key -->
                        <xsl:for-each select="key('getUeDeEnseignant',$identif)">
                            <xsl:variable name="ue" select="./nom"></xsl:variable>
                            <li>
                                <a href="../UEs/{$ue}.html">
                                    <xsl:value-of select="$ue"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </body>
            </html>

        </xsl:result-document>

    </xsl:template>

    <xsl:template name="liste-des-unites">
        <!-- nom, identifiant, nbcredit, resume?, plan?, lieu?, refintervenant -->

        <h1>Liste des ues</h1>
        <xsl:for-each select="/descendant::ue">
            <xsl:variable name="name" select="./nom"></xsl:variable>
            <xsl:result-document href="www/UEs/{$name}.html">
                <meta charset="iso-8859-1"/>
                <html>
                    <body>
                        <xsl:call-template name="menuStatique"/>
                        <o1>
                            <li>
                                <xsl:value-of select="nom"/>
                            </li>
                            <li>
                                <xsl:value-of select="identifiant"/>
                            </li>
                            <li>
                                <xsl:value-of select="nbcredit"/>
                            </li>
                            <li>
                                <xsl:value-of select="lieu"/>
                            </li>
                            <li>
                                <xsl:value-of select="refintervenant"/>
                            </li>
                        </o1>

                        <h2>Liste des parcours contenant cette UE :</h2>
                        <xsl:variable name="idSemestre" select="ancestor::semestre/@id"/>
                        <ol>
                            <xsl:for-each select="//parcours/ref-semestre[@ref=$idSemestre]/../nom">
                                <xsl:variable name="parcoursName" select="."/>

                                <li>
                                    <a href="../parcours/{$parcoursName}.html">
                                        <xsl:value-of select="$parcoursName"/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ol>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="liste-des-parcours">
        <!-- nom, listeResponsables, description, listeDebouches,ref-semestre+ -->
        <xsl:for-each select="//parcours">
            <xsl:variable name="name" select="./nom"></xsl:variable>
            <xsl:result-document href="www/parcours/{$name}.html">
                <html>
                    <meta charset="UTF-8"/> <!-- Préférer à iso 8859-1 ?? caractères illisibles-->
                    <link rel="stylesheet" type="text/css" href="../../style.css"/>
                    <body>
                        <xsl:call-template name="menuStatique"/>
                        <h1>
                            <xsl:value-of select="nom"/>
                        </h1>
                        <h2>Les responsables du master sont :</h2>
                        <ol>
                            <xsl:for-each select="./listeResponsables/responsable">
                                <li>
                                    <xsl:value-of select="."></xsl:value-of>
                                </li>
                            </xsl:for-each>
                        </ol>

                        <h2>Description du parcours :</h2>
                        <!-- Avoir recours à la substitution = créer template spéciale OU pleins de match? -->
                        <xsl:apply-templates select="description"/>
                        <xsl:apply-templates select="listeDebouches"/>


                        <xsl:for-each select="ref-semestre">
                            <xsl:call-template name="liste-ues-du-semestre">
                                <xsl:with-param name="refSemestre">
                                    <xsl:value-of select="@ref"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <!-- Templates match nécessaires pour la page de présentation du parcours -->

    <xsl:template match="paragraphe">
        <p>
            <xsl:value-of select="."/>
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

    <xsl:template match="listeDebouches">
        <h2>Liste des débouchés possibles :</h2>
        <ul>
            <xsl:for-each select="metier">
                <li>
                    <xsl:value-of select="."/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

</xsl:stylesheet>



  






