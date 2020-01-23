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
  <xsl:param name="isTeam"         />
  <xsl:param name="rankType"       />
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
            <xsl:value-of select="$localized/ft:LocText[@id='TemporaryPoolResults']" />
          </h2>

          <div>
            <table class="dataTable">
              <xsl:variable name="results" select="/ArrayOfTemporaryPoolResult/TemporaryPoolResult" />

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
                  
                <xsl:if test="$showClubs = 'true' and ($results/PrimaryClubAbbr[.!=''] or $results/SecondaryClubAbbr[.!=''])">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Clubs']" />
                  </th>
                </xsl:if>
                  
                <xsl:if test="$showDivs = 'true' and $results/DivisionAbbr[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Division']" />
                  </th>
                </xsl:if>
                  
                <xsl:if test="$showCountries = 'true' and $results/CountryAbbr[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Country']" />
                  </th>
                </xsl:if>

                <th>V</th>
                <th>V/M</th>
                <th>
                  <xsl:value-of select="$localized/ft:LocText[@id='TS']" />
                </th>
                <th>
                  <xsl:value-of select="$localized/ft:LocText[@id='TR']" />
                </th>
                <th>Ind</th>
                  
                <th>
                  <xsl:value-of select="$localized/ft:LocText[@id='Status']" />
                </th>
              </tr>

              <xsl:for-each select="$results">
                <tr>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                      <xsl:otherwise>oddRow</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>

                  <td>
                    <xsl:value-of select="Place" />
                  </td>

                  <td>
                    <xsl:value-of select="Name" />
                  </td>

                  <xsl:if test="$showClubs = 'true' and ($results/PrimaryClubAbbr[.!=''] or $results/SecondaryClubAbbr[.!=''])">
                    <td>
                      <xsl:call-template name="BuildClubNames">
                        <xsl:with-param name="club1Abbr" select="PrimaryClubAbbr" />
                        <xsl:with-param name="club2Abbr" select="SecondaryClubAbbr" />
                      </xsl:call-template>
                    </td>
                  </xsl:if>

                  <xsl:if test="$showDivs = 'true' and $results/DivisionAbbr[.!='']">
                    <td>
                      <xsl:value-of select="DivisionAbbr" />
                    </td>
                  </xsl:if>

                  <xsl:if test="$showCountries = 'true' and $results/CountryAbbr[.!='']">
                    <td>
                      <xsl:if test="CountryAbbr != ''">
                        <img src="{$flagPath}\Flags\{CountryAbbr}.png" />
                        <xsl:text xml:space="preserve">  </xsl:text>
                        <xsl:value-of select="CountryAbbr" />
                      </xsl:if>
                      </td>
                  </xsl:if>

                  <td><xsl:value-of select="Victories"/></td>
                  <td><xsl:value-of select="format-number(WinPercentage, '0.00')"/></td>
                  <td><xsl:value-of select="TouchesScored"/></td>
                  <td><xsl:value-of select="TouchesReceived"/></td>
                  <td>
                    <xsl:if test="Indicator = 0">0</xsl:if>
                    <xsl:if test="Indicator != 0"><xsl:value-of select="format-number(Indicator, '+#;-#')"/></xsl:if>
                  </td>

                  <td>
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="Prediction = 'CertainPromotion'">tempResultsPromoted</xsl:when>
                        <xsl:when test="Prediction = 'LikelyPromotion'">tempResultsPromoted</xsl:when>
                        <xsl:when test="Prediction = 'PossiblePromotion'">tempResultsUncertain</xsl:when>
                        <xsl:when test="Prediction = 'PossibleElimination'">tempResultsUncertain</xsl:when>
                        <xsl:when test="Prediction = 'LikelyElimination'">tempResultsEliminated</xsl:when>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:variable name="status" select="Prediction" />
                    <xsl:value-of select="$localized/ft:LocText[@id=$status]" />
                  </td>
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
