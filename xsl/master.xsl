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
    <xsl:include href="description.xsl"/>

    <xsl:output
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
            method="html"/>

    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <meta charset="UTF-8"/>
                <link rel="stylesheet" type="text/css" href="../../style.css"/>
                <title>Bienvenue au Département d'Informatique</title>
            </head>
            <body>
                <xsl:call-template name="menuStatique"/>
                <h2>Les parcours proposés pour le M1 Informatique :</h2>
                <ol>
                    <xsl:for-each select="//parcours">
                        <xsl:variable name="parcoursName" select="./nom"/>
                        <li>
                            <a href="../parcours/{$parcoursName}.html">
                                <xsl:value-of select="$parcoursName"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ol>

                <xsl:call-template name="liste-des-enseignants"/>
                <xsl:call-template name="liste-des-unites"/>
                <xsl:call-template name="liste-des-parcours"/>
                <xsl:call-template name="listesUesEtEnseignants"/>
            </body>
        </html>

    </xsl:template>

    <xsl:template name="liste-des-enseignants">
        <xsl:apply-templates select="//listeIntervenants"/>
    </xsl:template>

    <!--Permet de retrouver UE facilement à partir ID des enseignants-->
    <xsl:key name="getUeDeEnseignant" match="ue" use="refintervenant/@ref"/>

    <xsl:template match="intervenant">
        <xsl:variable name="name" select="./nom"></xsl:variable>
        <xsl:variable name="identif" select="@id"></xsl:variable>

        <xsl:result-document href="www/intervenants/{$name}.html">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta charset="UTF-8"/>
                    <link rel="stylesheet" type="text/css" href="../../style.css"/>
                    <title>{$name}</title>
                </head>
                <body>
                    <xsl:call-template name="menuStatique"/>
                    <ul>
                        <li>
                            <h2>
                                <xsl:value-of select="$name"/>
                            </h2>
                        </li>
                        <li>
                            mail :
                            <xsl:value-of select="./mail"/>
                        </li>
                        <li>
                            site perso :
                            <xsl:value-of select="./site"/>
                        </li>
                    </ul>
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

    <xsl:key name="getNameDeEnseignant" match="intervenant" use="@id"/>

    <xsl:template name="liste-des-unites">
        <!-- nom, identifiant, nbcredit, resume?, plan?, lieu?, refintervenant -->

        <xsl:for-each select="/descendant::ue">
            <xsl:variable name="name" select="./nom"></xsl:variable>
            <xsl:variable name="UE" select="."></xsl:variable>
            <xsl:result-document href="www/UEs/{$name}.html">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <head>
                        <meta charset="UTF-8"/>
                        <link rel="stylesheet" type="text/css" href="../../style.css"/>
                        <title>{$name}</title>
                    </head>
                    <body>
                        <xsl:call-template name="menuStatique"/>
                        <ul>
                            <li>
                                <h4>nom:</h4>
                                <xsl:value-of select="nom"/>
                            </li>
                            <li>
                                <h4>nombre de crédit:</h4>
                                <xsl:value-of select="nbcredit"/>
                            </li>

                            <!-- Ces champs étant facultatifs, il faut des conditions -->
                            <xsl:variable name="lieu" select="lieu"/>
                            <xsl:choose>
                                <xsl:when test="$lieu!=''">
                                    <li>
                                        <h4>lieu:</h4>
                                        <xsl:value-of select="$lieu"/>
                                    </li>
                                </xsl:when>
                            </xsl:choose>

                            <xsl:variable name="plan" select="plan"/>
                            <xsl:choose>
                                <xsl:when test="$plan!=''">
                                    <li>
                                        <h4>plan:</h4>
                                        <xsl:value-of select="plan"/>
                                    </li>
                                </xsl:when>
                            </xsl:choose>

                            <xsl:variable name="resume" select="resume"/>
                            <xsl:choose>
                                <xsl:when test="$resume!=''">
                                    <li>
                                        <h4>Description:</h4>
                                        <xsl:apply-templates select="resume"/>
                                    </li>
                                </xsl:when>
                            </xsl:choose>
                            <xsl:variable name="refEnseignant" select="refintervenant"/>
                            <li>
                                <h4>Enseignant:</h4>
                                <xsl:value-of select="key('getNameDeEnseignant',$refEnseignant/@ref)/nom"/>
                            </li>
                        </ul>

                        <h2>Liste des parcours contenant cette UE :</h2>
                        <xsl:variable name="idUE" select="$UE/@id"/>
                        <ol>
                            <xsl:for-each select="//semestre[bloc/ref-ue/@ref=$idUE]">
                                <xsl:variable name="idSemestre" select="@id"/>
                                <xsl:for-each select="//parcours[ref-semestre/@ref=$idSemestre]">
                                    <xsl:variable name="parcoursName" select="./nom"/>
                                    <li>
                                        <a href="../parcours/{$parcoursName}.html">
                                            <xsl:value-of select="$parcoursName"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
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
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <head>
                        <meta charset="UTF-8"/>
                        <link rel="stylesheet" type="text/css" href="../../style.css"/>
                        <title>{$name}</title>
                    </head>
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
                        <xsl:apply-templates/>


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



  






