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
  <xsl:param name="isTeam"   />
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
          <xsl:variable name="allComps" select="/ArrayOfCompetitor/Competitor" />

          <h2>
            <xsl:if test="$isTeam = 'true'">
              <xsl:value-of  select="$localized/ft:LocText[@id='EventTeams']" />
            </xsl:if>
            <xsl:if test="$isTeam = 'false'">
              <xsl:value-of select="$localized/ft:LocText[@id='EventCompetitors']" />
            </xsl:if>
          </h2>
            
          <h5>
            <xsl:value-of select="count($allComps[CheckInStatus='Checked-In'])" />&#160;
            <xsl:value-of select="$localized/ft:LocText[@id='of']" />&#160;
            <xsl:value-of select="count($allComps)" />&#160;
            <xsl:if test="$isTeam = 'true'">
              <xsl:value-of select="$localized/ft:LocText[@id='teams']" />
            </xsl:if>
            <xsl:if test="$isTeam = 'false'">
              <xsl:value-of select="$localized/ft:LocText[@id='fencers']" />
            </xsl:if>
            &#160;<xsl:value-of select="$localized/ft:LocText[@id='checkedin']" />.
          </h5>

          <xsl:variable name="hasClubs"     select="$allComps/PrimaryClubAbbr[.!=''] or $allComps/SecondaryClubAbbr[.!='']" />
          <xsl:variable name="hasDivs"      select="$allComps/DivisionAbbr[.!='']" />
          <xsl:variable name="hasCountries" select="$allComps/CountryAbbr[.!='']" />
            
          <xsl:if test="$isTeam = 'false'">
            <div>
              <table class="dataTable">
                <tr class="headerRow">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Status']" />
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                  </th>
                  <th>
                    <xsl:choose>
                      <xsl:when test="$rankType='rating'"><xsl:value-of select="$localized/ft:LocText[@id='Class']" /></xsl:when>
                      <xsl:when test="$rankType='rank'"><xsl:value-of select="$localized/ft:LocText[@id='Rank']" /></xsl:when>
                      <xsl:when test="$rankType='rankrating'"><xsl:value-of select="$localized/ft:LocText[@id='ClassRank']" /></xsl:when>
                      <xsl:when test="$rankType='points'"><xsl:value-of select="$localized/ft:LocText[@id='Points']" /></xsl:when>
                    </xsl:choose>
                  </th>

                  <xsl:if test="$showClubs = 'true' and $hasClubs">
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Clubs']" /></th>
                  </xsl:if>
                  <xsl:if test="$showDivs = 'true' and $hasDivs">
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Division']" /></th>
                  </xsl:if>
                  <xsl:if test="$showCountries = 'true' and $hasCountries">
                    <th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th>
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

                    <td>
                      <xsl:attribute name="class">
                        <xsl:if test="CheckInStatus = 'Checked-In'">checkedIn</xsl:if>
                        <xsl:if test="CheckInStatus = 'Scratched'">scratched</xsl:if>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="CheckInStatus = 'Checked-In'">
                          <img style="margin: 4px;" src="{$localPath}/CheckIn.png" />
                        </xsl:when>
                        <xsl:when test="CheckInStatus = 'Scratched'">
                          <img style="margin: 4px;" src="{$localPath}/Scratch.png" />
                        </xsl:when>
                      </xsl:choose>
                    </td>

                    <td>
                      <xsl:value-of select="Name" />
                    </td>

                    <td>
                      <xsl:value-of select="Rank" />
                    </td>

                    <xsl:if test="$showClubs = 'true' and $hasClubs">
                      <td>
                        <xsl:call-template name="BuildClubNames">
                          <xsl:with-param name="club1Abbr" select="PrimaryClubAbbr" />
                          <xsl:with-param name="club2Abbr" select="SecondaryClubAbbr" />
                        </xsl:call-template>
                      </td>
                    </xsl:if>

                    <xsl:if test="$showDivs = 'true' and $hasDivs">
                      <td>
                        <xsl:value-of select="DivisionAbbr" />
                      </td>
                    </xsl:if>

                    <xsl:if test="$showCountries = 'true' and $hasCountries">
                      <td>
                        <xsl:if test="CountryAbbr != ''">
                          <img src="{$flagPath}\Flags\{CountryAbbr}.png" />
                          <xsl:text xml:space="preserve">  </xsl:text>
                          <xsl:value-of select="CountryAbbr" />
                        </xsl:if>
                      </td>
                    </xsl:if>
                  </tr>
                </xsl:for-each>
              </table>
            </div>
          </xsl:if>

  
          <xsl:if test="$isTeam = 'true'">
            <xsl:variable name="hasBirthdates" select="$allComps/TeamData/TeamFencers/TeamFencer/Birthdate[.!='']" />
            <xsl:variable name="hasGenders"    select="$allComps/TeamData/TeamFencers/TeamFencer/IsMale[.!='']" />
            <xsl:variable name="hasWeapons"    select="$allComps/TeamData/TeamFencers/TeamFencer/WeaponOrReserve[.!='']" />

            <div>
              <table class="dataTable">
                <col width="6%" />
                <col width="40%" />
                <col width="19%" />
                <col width="13%" />
                <col width="9%" />
                <col width="13%" />
                
                <tr class="headerRow">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Status']" />
                    <br/>
                    &#160;
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='TeamName']" />
                    <br/>
                    &#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='FencerName']" />
                  </th>
                  <th>
                    <xsl:if test="$showClubs = 'true' and $hasClubs">
                      <xsl:value-of select="$localized/ft:LocText[@id='Club']" />
                    </xsl:if>
                    <br />
                    <xsl:if test="$hasWeapons">
                      &#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='Weapon']" />
                    </xsl:if>
                    &#160;
                  </th>
                  <th>
                    <xsl:if test="$showDivs = 'true' and $hasDivs">
                      <xsl:value-of select="$localized/ft:LocText[@id='Division']" />
                    </xsl:if>
                    <br/>
                    <xsl:if test="$hasBirthdates">
                      &#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='Birthdate']" />
                    </xsl:if>
                    &#160;
                  </th>
                  <th>
                    <xsl:if test="$showCountries = 'true' and $hasCountries">
                      <xsl:value-of select="$localized/ft:LocText[@id='Country']" />
                    </xsl:if>
                    <br/>
                    <xsl:if test="$hasGenders">
                      &#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='Gender']" />
                    </xsl:if>
                    &#160;
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='TeamRank']" />
                    <br/>
                    &#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='FencerRank']" />
                    &#160;
                  </th>
                </tr>

                <xsl:for-each select="$allComps">
                  <xsl:variable name="class">
                    <xsl:choose>
                      <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                      <xsl:otherwise>oddRow</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <tr class="{$class}">
                    <td>
                      <xsl:attribute name="class">
                        <xsl:if test="CheckInStatus = 'Checked-In'">checkedIn</xsl:if>
                        <xsl:if test="CheckInStatus = 'Scratched'">scratched</xsl:if>
                      </xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="CheckInStatus = 'Checked-In'">
                          <img style="margin: 4px;" src="{$localPath}/CheckIn.png" />
                        </xsl:when>
                        <xsl:when test="CheckInStatus = 'Scratched'">
                          <img style="margin: 4px;" src="{$localPath}/Scratch.png" />
                        </xsl:when>
                      </xsl:choose>
                    </td>

                    <td>
                      <xsl:value-of select="Name" />
                    </td>

                    <td>
                      <xsl:if test="$showClubs = 'true' and $hasClubs">
                        <xsl:value-of select="PrimaryClubAbbr" />
                      </xsl:if>
                      &#160;
                    </td>

                    <td>
                      <xsl:if test="$showDivs = 'true' and $hasDivs">
                        <xsl:value-of select="DivisionAbbr" />
                      </xsl:if>
                      &#160;
                    </td>

                    <td>
                      <xsl:if test="$showCountries = 'true' and $hasCountries">
                        <xsl:if test="CountryAbbr != ''">
                          <img src="{$flagPath}\Flags\{CountryAbbr}.png" />
                          <xsl:text xml:space="preserve">  </xsl:text>
                          <xsl:value-of select="CountryAbbr" />
                        </xsl:if>
                      </xsl:if>
                    </td>

                    <td>
                      <xsl:if test="Rank &gt; 0">
                        <xsl:value-of select="Rank" />
                      </xsl:if>
                      &#160;
                    </td>
                  </tr>

                  <xsl:for-each select="TeamData/TeamFencers/TeamFencer">
                    <tr class="{$class}">
                      <td>&#160;</td>
                      <td>&#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="Name" /></td>
                      <td>
                        <xsl:if test="$hasWeapons">
                          &#160;&#160;&#160;&#160;&#160;&#160;
                          <xsl:if test="WeaponOrReserve = 'F'"><xsl:value-of select="$localized/ft:LocText[@id='foil']" /></xsl:if>
                          <xsl:if test="WeaponOrReserve = 'E'"><xsl:value-of select="$localized/ft:LocText[@id='epee']" /></xsl:if>
                          <xsl:if test="WeaponOrReserve = 'S'"><xsl:value-of select="$localized/ft:LocText[@id='saber']" /></xsl:if>
                          <xsl:if test="WeaponOrReserve = 'R'"><xsl:value-of select="$localized/ft:LocText[@id='Reserve']" /></xsl:if>
                        </xsl:if>
                        &#160;
                      </td>
                      <td>
                        <xsl:if test="$hasBirthdates">
                          &#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="substring-before(string(Birthdate),'T')" />
                        </xsl:if>
                        &#160;
                      </td>
                      <td>
                        <xsl:if test="$hasGenders">
                          &#160;&#160;&#160;&#160;&#160;&#160;
                          <xsl:if test="IsMale = 'true'"><xsl:value-of select="$localized/ft:LocText[@id='Male']" /></xsl:if>
                          <xsl:if test="IsMale = 'false'"><xsl:value-of select="$localized/ft:LocText[@id='Female']" /></xsl:if>
                        </xsl:if>
                        &#160;
                      </td>
                      <td>
                        &#160;&#160;&#160;&#160;&#160;&#160;<xsl:if test="RankOrPoints &gt; 0"><xsl:value-of select="RankOrPoints" /></xsl:if>
                      </td>
                    </tr>
                  </xsl:for-each>  
                </xsl:for-each>
              </table>
            </div>
          </xsl:if>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:include href="Transform\Common.xslt" />
</xsl:stylesheet>
