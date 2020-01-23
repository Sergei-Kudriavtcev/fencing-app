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
  <xsl:param name="bIsInitialSeed" />
  <xsl:param name="hasPoolResults" />
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
            <xsl:if test="$bIsInitialSeed = 'false'">
              <xsl:value-of select="$localized/ft:LocText[@id='CurrentSeeding']" />
            </xsl:if>
            <xsl:if test="$bIsInitialSeed = 'true'">
              <xsl:value-of select="$localized/ft:LocText[@id='InitialSeeding']" />
            </xsl:if>
          </h2>

          <div>
            <table class="dataTable">
              <xsl:variable name="seeding" select="/ArrayOfSeeding/Seeding" />

              <tr class="headerRow">
                <th>
                  <xsl:value-of select="$localized/ft:LocText[@id='Seed']" />
                </th>
                  
                <th>
                  <xsl:if test="$isTeam = 'true'">
                    <xsl:value-of select="$localized/ft:LocText[@id='TeamName']" />
                  </xsl:if>
                  <xsl:if test="$isTeam = 'false'">
                    <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                  </xsl:if>
                </th>
                  
                <th>
                  <xsl:choose>
                    <xsl:when test="$rankType='rating'">
                      <xsl:value-of select="$localized/ft:LocText[@id='Class']" />
                    </xsl:when>
                    <xsl:when test="$rankType='rank'">
                      <xsl:value-of select="$localized/ft:LocText[@id='Rank']" />
                    </xsl:when>
                    <xsl:when test="$rankType='rankrating'">
                      <xsl:value-of select="$localized/ft:LocText[@id='ClassRank']" />
                    </xsl:when>
                    <xsl:when test="$rankType='points'">
                      <xsl:value-of select="$localized/ft:LocText[@id='Points']" />
                    </xsl:when>
                  </xsl:choose>
                </th>
                  
                <xsl:if test="$showClubs = 'true' and ($seeding/PrimaryClubAbbr[.!=''] or $seeding/SecondaryClubAbbr[.!=''])">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Clubs']" />
                  </th>
                </xsl:if>
                  
                <xsl:if test="$showDivs = 'true' and $seeding/DivisionAbbr[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Division']" />
                  </th>
                </xsl:if>
                  
                <xsl:if test="$showCountries = 'true' and $seeding/CountryAbbr[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Country']" />
                  </th>
                </xsl:if>

                <xsl:if test="$hasPoolResults = 'true'">
                  <th>V</th>
                  <th>V/M</th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='TS']" />
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='TR']" />
                  </th>
                  <th>Ind</th>
                </xsl:if>
                  
                <xsl:if test="$seeding/Status[.!='']">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Status']" />
                  </th>
                </xsl:if>
              </tr>

              <xsl:for-each select="/ArrayOfSeeding/Seeding">
                <tr>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                      <xsl:otherwise>oddRow</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>

                  <td>
                    <xsl:value-of select="Seed" />
                  </td>
                    
                  <td>
                    <xsl:if test="IsExcluded = 'true'">
                      <xsl:if test="FencerID != 0">
                        <xsl:value-of select="$localized/ft:LocText[@id='FencerExcluded']" />
                      </xsl:if>
                      <xsl:if test="TeamID != 0">
                        <xsl:value-of select="$localized/ft:LocText[@id='TeamExcluded']" />
                      </xsl:if>
                    </xsl:if>
                    <xsl:if test="IsExcluded = 'false'">
                      <xsl:value-of select="Name" />
                    </xsl:if>
                  </td>

                  <td>
                    <xsl:if test="Rank != 0">
                      <xsl:value-of select="Rank" />
                    </xsl:if>
                  </td>

                  <xsl:if test="$showClubs = 'true' and ($seeding/PrimaryClubAbbr[.!=''] or $seeding/SecondaryClubAbbr[.!=''])">
                    <td>
                      <xsl:call-template name="BuildClubNames">
                        <xsl:with-param name="club1Abbr" select="PrimaryClubAbbr" />
                        <xsl:with-param name="club2Abbr" select="SecondaryClubAbbr" />
                      </xsl:call-template>
                    </td>
                  </xsl:if>

                  <xsl:if test="$showDivs = 'true' and $seeding/DivisionAbbr[.!='']">
                    <td>
                      <xsl:value-of select="DivisionAbbr" />
                    </td>
                  </xsl:if>

                  <xsl:if test="$showCountries = 'true' and $seeding/CountryAbbr[.!='']">
                    <td>
                      <xsl:if test="CountryAbbr != ''">
                        <img src="{$flagPath}\Flags\{CountryAbbr}.png" />
                        <xsl:text xml:space="preserve">  </xsl:text>
                        <xsl:value-of select="CountryAbbr" />
                      </xsl:if>
                      </td>
                  </xsl:if>

                  <!-- If page is showing pool results, include columns-->
                  <xsl:if test="$hasPoolResults = 'true'">
                    <!-- Fill in values if competitor has results -->
                    <xsl:if test="HasPoolResults = 'true' and IsExcluded = 'false'">
                      <td><xsl:value-of select="PoolVictories"/></td>
                      <td><xsl:value-of select="format-number(PoolWinPercentage, '0.00')"/></td>
                      <td><xsl:value-of select="PoolTouchesScored"/></td>
                      <td><xsl:value-of select="PoolTouchesReceived"/></td>
                      <td>
                        <xsl:if test="PoolIndicator = 0">0</xsl:if>
                        <xsl:if test="PoolIndicator != 0"><xsl:value-of select="format-number(PoolIndicator, '+#;-#')"/></xsl:if>
                      </td>
                    </xsl:if>
                    <xsl:if test="HasPoolResults = 'false' or IsExcluded = 'true'">
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td></td>
                    </xsl:if>
                  </xsl:if>

                  <xsl:if test="$seeding/Status[.!='']">
                    <td>
                      <xsl:attribute name="class">
                        <xsl:choose>
                          <xsl:when test="Status = 'Eliminated'">seedingEliminated</xsl:when>
                          <xsl:otherwise>seedingAdvanced</xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>

                      <xsl:variable name="status" select="Status" />
                      <xsl:value-of select="$localized/ft:LocText[@id=$status]" />
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
