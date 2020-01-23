﻿<?xml version="1.0" encoding="utf-8"?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:output indent="yes" />
  <xsl:variable name="fileVersion">4.3</xsl:variable>

  <!-- Standard parameters -->
  <xsl:param name="localPath"  />
  <xsl:param name="flagPath"   />
  <xsl:param name="fontSize"   />
  <xsl:param name="langCode"   />
  <xsl:param name="bgClass"    />

  <!-- Page-specific parameters -->
  <xsl:param name="rankType" />
  <xsl:param name="showClubs"     />
  <xsl:param name="showDivs"      />
  <xsl:param name="showCountries" />

  <xsl:variable name="localized" select="document(concat('Lang\', $langCode, '.xml'))/ft:LocalizedText" />
  
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link rel="stylesheet" type="text/css" href="{$localPath}/Styles/default.css" />
      </head>

      <body class="{$bgClass}" style="font-size: {$fontSize}em;">
        <div class="page">
          <xsl:variable name="allComps" select="/ArrayOfFencer/Fencer" />

          <h2>
            <xsl:value-of select="$localized/ft:LocText[@id='EventCompetitors']" />
          </h2>
            
          <div>
            <table class="dataTable">
              <tr class="headerRow">
                <xsl:if test="$showCountries = 'true' and $allComps/CountryAbbr[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Country']" />
                  </th>
                </xsl:if>

                <th>
                  <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                </th>

                <xsl:if test="$rankType='rating' or $rankType='rankrating'">
                  <th>
                      <xsl:value-of select="$localized/ft:LocText[@id='Class']" />
                  </th>
                </xsl:if>

                <xsl:if test="$rankType='rank' or $rankType='rankrating'">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Rank']" />
                  </th>
                </xsl:if>

                <xsl:if test="$showClubs = 'true' and ($allComps/PrimaryClubAbbr[.!=''] or $allComps/SecondaryClubAbbr[.!=''])">
                  <th><xsl:value-of select="$localized/ft:LocText[@id='Clubs']" /></th>
                </xsl:if>
                <xsl:if test="$showDivs = 'true' and $allComps/DivisionAbbr[.!='']">
                  <th><xsl:value-of select="$localized/ft:LocText[@id='Division']" /></th>
                </xsl:if>
              </tr>

              <xsl:for-each select="$allComps">
                <tr>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                      <xsl:otherwise>oddRow</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>

                  <xsl:if test="$showCountries = 'true' and $allComps/CountryAbbr[.!='']">
                    <td>
                      <xsl:if test="CountryAbbr != ''">
                        <img src="{$flagPath}\Flags\{CountryAbbr}.png" />
                        <xsl:text xml:space="preserve">  </xsl:text>
                        <xsl:value-of select="CountryAbbr" />
                      </xsl:if>
                    </td>
                  </xsl:if>

                  <td>
                    <xsl:value-of select="Name" />
                  </td>

                  <xsl:if test="$rankType='rating' or $rankType='rankrating'">
                    <td>
                      <xsl:value-of select="Rating" />
                    </td>
                  </xsl:if>

                  <xsl:if test="$rankType='rank' or $rankType='rankrating'">
                    <td>
                      <xsl:value-of select="Rank1" />
                    </td>
                  </xsl:if>

                  <xsl:if test="$showClubs = 'true' and ($allComps/PrimaryClubAbbr[.!=''] or $allComps/SecondaryClubAbbr[.!=''])">
                    <td>
                      <xsl:call-template name="BuildClubNames">
                        <xsl:with-param name="club1Abbr" select="PrimaryClubAbbr" />
                        <xsl:with-param name="club2Abbr" select="SecondaryClubAbbr" />
                      </xsl:call-template>
                    </td>
                  </xsl:if>

                  <xsl:if test="$showDivs = 'true' and $allComps/DivisionAbbr[.!='']">
                    <td>
                      <xsl:value-of select="DivisionAbbr" />
                    </td>
                  </xsl:if>
                </tr>
              </xsl:for-each>
            </table>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:include href="Transform\Common.xslt" />
</xsl:stylesheet>
