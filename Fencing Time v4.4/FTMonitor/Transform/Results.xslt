<?xml version="1.0" encoding="utf-8"?>
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
  <xsl:param name="isTeam" />
  <xsl:param name="isFinal" />
  <xsl:param name="isQual" />
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
          <h2>
            <xsl:if test="$isFinal = 'true'">
              <xsl:value-of select="$localized/ft:LocText[@id='FinalResults']" />
            </xsl:if>
            <xsl:if test="$isFinal = 'false'">
              <xsl:value-of select="$localized/ft:LocText[@id='ResultsSoFar']" />
            </xsl:if>
          </h2>

          <div>
            <table class="dataTable">
              <xsl:variable name="allResults" select="/ArrayOfResult/Result" />

              <tr class="headerRow">
                <th>
                  <xsl:value-of select="$localized/ft:LocText[@id='Place']" />
                </th>
                  
                <th>
                  <xsl:if test="$isTeam = 'true'">
                    <xsl:value-of select="$localized/ft:LocText[@id='TeamName']" />
                  </xsl:if>
                  <xsl:if test="$isTeam = 'false'">
                    <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                  </xsl:if>
                </th>

                <xsl:if test="$showClubs = 'true' and ($allResults/PrimaryClubAbbr[.!=''] or $allResults/SecondaryClubAbbr[.!=''])">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Clubs']" />
                  </th>
                </xsl:if>
                  
                <xsl:if test="$showDivs = 'true' and $allResults/DivisionAbbr[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Division']" />
                  </th>
                </xsl:if>
                  
                <xsl:if test="$showCountries = 'true' and $allResults/CountryAbbr[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Country']" />
                  </th>
                </xsl:if>
                  
                <xsl:if test="$allResults/Rating[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Class']" />
                  </th>
                    
                  <xsl:if test="$isFinal = 'true'">
                    <th>
                      <xsl:value-of select="$localized/ft:LocText[@id='Earned']" />
                    </th>
                  </xsl:if>
                </xsl:if>
                  
                <xsl:if test="$isQual = 'true'">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='QualFor']" />
                  </th>
                </xsl:if>
              </tr>

              <xsl:for-each select="/ArrayOfResult/Result">
                <tr>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="IsExcluded = 'true'">excludedRow</xsl:when>
                      <xsl:when test="FinalPlace = '1' or FinalPlace = '1T'">goldResultRow</xsl:when>
                      <xsl:when test="FinalPlace = '2' or FinalPlace = '2T'">silverResultRow</xsl:when>
                      <xsl:when test="FinalPlace = '3' or FinalPlace = '3T'">bronzeResultRow</xsl:when>
                      <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                      <xsl:otherwise>oddRow</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>

                  <td>
                    <xsl:value-of select="FinalPlace" />
                  </td>

                  <td>
                    <xsl:if test="IsExcluded = 'true'">
                      <xsl:if test="FencerID != 0"><xsl:value-of select="$localized/ft:LocText[@id='FencerExcluded']" /></xsl:if>
                      <xsl:if test="TeamID   != 0"><xsl:value-of select="$localized/ft:LocText[@id='TeamExcluded']" /></xsl:if>
                    </xsl:if>
                    <xsl:if test="IsExcluded = 'false'">
                      <xsl:value-of select="Name" />
                    </xsl:if>
                  </td>

                  <xsl:if test="$showClubs = 'true' and ($allResults/PrimaryClubAbbr[.!=''] or $allResults/SecondaryClubAbbr[.!=''])">
                    <td>
                      <xsl:if test="IsExcluded = 'false'">
                        <xsl:call-template name="BuildClubNames">
                          <xsl:with-param name="club1Abbr" select="PrimaryClubAbbr" />
                          <xsl:with-param name="club2Abbr" select="SecondaryClubAbbr" />
                        </xsl:call-template>
                      </xsl:if>
                    </td>
                  </xsl:if>

                  <xsl:if test="$showDivs = 'true' and $allResults/DivisionAbbr[.!='']">
                    <td>
                      <xsl:if test="IsExcluded = 'false'">
                        <xsl:value-of select="DivisionAbbr" />
                      </xsl:if>
                    </td>
                  </xsl:if>

                  <xsl:if test="$showCountries = 'true' and $allResults/CountryAbbr[.!='']">
                    <td>
                      <xsl:if test="IsExcluded = 'false' and CountryAbbr != ''">
                        <img src="{$flagPath}\Flags\{CountryAbbr}.png" />
                        <xsl:text xml:space="preserve">  </xsl:text>
                        <xsl:value-of select="CountryAbbr" />
                      </xsl:if>
                    </td>
                  </xsl:if>

                  <xsl:if test="$allResults/Rating[.!='']">
                    <td>
                      <xsl:if test="IsExcluded = 'false'">
                        <xsl:value-of select="Rating" />
                      </xsl:if>
                    </td>
                    <xsl:if test="$isFinal = 'true'">
                      <td>
                        <xsl:if test="IsExcluded = 'false'">
                          <xsl:value-of select="EarnedRating" />
                        </xsl:if>
                      </td>
                    </xsl:if>
                  </xsl:if>

                  <xsl:if test="$isQual = 'true'">
                    <td>
                      <xsl:if test="IsExcluded = 'false'">
                        <xsl:value-of select="QualifiedFor" />
                      </xsl:if>
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
