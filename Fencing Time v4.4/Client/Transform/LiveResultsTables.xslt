<?xml version="1.0" encoding="UTF-8" ?>
<!-- 
Fencing Time
By Daniel Berke
(C) Copyright by Daniel Berke 
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ft="http://www.fencingtime.com">
  <xsl:variable name="fileVersion2">4.4</xsl:variable>

  <!-- Template to render check-in list -->
  <xsl:template name="RenderCheckIn">
    <xsl:param name="comps"  />
    <xsl:param name="evType" />

    <div class="checkInSummary">
      <xsl:value-of select="count($comps/ft:Competitor[@Status='CheckedIn'])" />&#160;
      <xsl:value-of select="$localized/ft:LocText[@id='Of']" />&#160;
      <xsl:value-of select="count($comps/ft:Competitor)" />&#160;
      <xsl:value-of select="$localized/ft:LocText[@id='CompsCheckedIn']" />
    </div>

    <xsl:variable name="hasClubs"     select="$comps/*/@Club" />
    <xsl:variable name="hasDivs"      select="$comps/*/@Division" />
    <xsl:variable name="hasCountries" select="$comps/*/@Country" />

    <xsl:if test="$evType = 'Individual'">
      <table class="dataTable">
        <!-- Table header row -->
        <tr class="dataTableHeaderRow">
          <th>
            <xsl:value-of select="$localized/ft:LocText[@id='Status']" />
          </th>
          <th>
            <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
          </th>
          <xsl:if test="$hasClubs">
            <th>
              <xsl:value-of select="$localized/ft:LocText[@id='Clubs']" />
            </th>
          </xsl:if>
          <xsl:if test="$hasDivs">
            <th>
              <xsl:value-of select="$localized/ft:LocText[@id='Division']" />
            </th>
          </xsl:if>
          <xsl:if test="$hasCountries">
            <th>
              <xsl:value-of select="$localized/ft:LocText[@id='Country']" />
            </th>
          </xsl:if>
        </tr>

        <!-- Competitor rows -->
        <xsl:for-each select="$comps/ft:Competitor">
          <xsl:sort select="@Name" />

          <tr>
            <xsl:choose>
              <xsl:when test="position() mod 2 = 1">
                <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
              </xsl:when>
              <xsl:when test="position() mod 2 = 0">
                <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
              </xsl:when>
            </xsl:choose>

            <xsl:if test="@Status = 'Scratched'">
              <xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
            </xsl:if>

            <td class="checkin">
              <xsl:choose>
                <xsl:when test="@Status = 'CheckedIn'">
                  <img src="CheckIn.png" />
                </xsl:when>
                <xsl:when test="@Status = 'Scratched'">
                  <img src="Scratch.png" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text xml:space="preserve">&#160;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </td>

            <td>
              <xsl:value-of select="@Name" />
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>

            <xsl:if test="$hasClubs">
              <td>
                <xsl:value-of select="@Club" />
                <xsl:text xml:space="preserve">&#160;</xsl:text>
              </td>
            </xsl:if>

            <xsl:if test="$hasDivs">
              <td>
                <xsl:value-of select="@Division" />
                <xsl:text xml:space="preserve">&#160;</xsl:text>
              </td>
            </xsl:if>

            <xsl:if test="$hasCountries">
              <td>
                <xsl:if test="@Country != ''">
                  <span class="flag flag{@Country}">
                    <xsl:comment> </xsl:comment>
                  </span>
                </xsl:if>
                <xsl:value-of select="@Country" />
                <xsl:text xml:space="preserve">&#160;</xsl:text>
              </td>
            </xsl:if>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>

    <xsl:if test="$evType = 'Team'">
      <xsl:variable name="hasBirthdates" select="$comps/ft:Competitor/ft:TeamFencers/*/@Birthdate" />
      <xsl:variable name="hasGenders"    select="$comps/ft:Competitor/ft:TeamFencers/*/@IsMale" />
      <table class="dataTable">
        <col width="6%" />
        <col width="46%" />
        <col width="13%" />
        <col width="13%" />
        <col width="9%" />
        <col width="13%" />

        <!-- Table header row -->
        <tr class="dataTableHeaderRow">
          <th>
            <xsl:value-of select="$localized/ft:LocText[@id='Status']" />
            <br/>
            &#160;
          </th>
          <th>
            <xsl:value-of select="$localized/ft:LocText[@id='TeamName']" />
            <br/>
            &#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='FencerName']" />
          </th>
          <th>
            <xsl:if test="$hasClubs">
              <xsl:value-of select="$localized/ft:LocText[@id='Club']" />
            </xsl:if>
            <br />
            &#160;
          </th>
          <th>
            <xsl:if test="$hasDivs">
              <xsl:value-of select="$localized/ft:LocText[@id='Division']" />
            </xsl:if>
            <br/>
            <xsl:if test="$hasBirthdates">
              &#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='Birthdate']" />
            </xsl:if>
            &#160;
          </th>
          <th>
            <xsl:if test="$hasCountries">
              <xsl:value-of select="$localized/ft:LocText[@id='Country']" />
            </xsl:if>
            <br/>
            <xsl:if test="$hasGenders">
              &#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='Gender']" />
            </xsl:if>
            &#160;
          </th>
          <th>
            <xsl:value-of select="$localized/ft:LocText[@id='TeamRank']" />
            <br/>
            &#160;&#160;&#160;<xsl:value-of select="$localized/ft:LocText[@id='FencerRank']" />
            &#160;
          </th>
        </tr>

        <!-- Competitor rows -->
        <xsl:for-each select="$comps/ft:Competitor">
          <xsl:sort select="@Name" />

          <xsl:variable name="class">
            <xsl:choose>
              <xsl:when test="position() mod 2 = 1">dataTableOddRow</xsl:when>
              <xsl:otherwise>dataTableEvenRow</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <tr class="{$class}">
            <xsl:if test="@Status = 'Scratched'">
              <xsl:attribute name="style">text-decoration: line-through;</xsl:attribute>
            </xsl:if>

            <td class="checkin">
              <xsl:choose>
                <xsl:when test="@Status = 'CheckedIn'">
                  <img src="CheckIn.png" />
                </xsl:when>
                <xsl:when test="@Status = 'Scratched'">
                  <img src="Scratch.png" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text xml:space="preserve">&#160;</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </td>

            <td>
              <xsl:value-of select="@Name" />
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>

            <td>
              <xsl:if test="$hasClubs">
                <xsl:value-of select="@ClubAbbr" />
                <xsl:text xml:space="preserve">&#160;</xsl:text>
              </xsl:if>
              &#160;
            </td>

            <td>
              <xsl:if test="$hasDivs">
                <xsl:value-of select="@Division" />
                <xsl:text xml:space="preserve">&#160;</xsl:text>
              </xsl:if>
              &#160;
            </td>

            <td>
              <xsl:if test="$hasCountries">
                <xsl:if test="@Country != ''">
                  <span class="flag flag{@Country}">
                    <xsl:comment> </xsl:comment>
                  </span>
                </xsl:if>
                <xsl:value-of select="@Country" />
                <xsl:text xml:space="preserve">&#160;</xsl:text>
              </xsl:if>
              &#160;
            </td>

            <td>
              <xsl:if test="@RankOrPoints &gt; 0">
                <xsl:value-of select="@RankOrPoints" />
              </xsl:if>
            </td>

            <xsl:for-each select="ft:TeamFencers/ft:TeamFencer">
              <xsl:sort select="@Name" />
              <tr class="{$class}">
                <td>&#160;</td>
                <td>
                  &#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="@Name" />
                </td>
                <td>&#160;</td>
                <td>
                  <xsl:if test="$hasBirthdates">
                    &#160;&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="@Birthdate" />
                  </xsl:if>
                  &#160;
                </td>
                <td>
                  <xsl:if test="$hasGenders">
                    &#160;&#160;&#160;&#160;&#160;&#160;
                    <xsl:if test="@IsMale = 'True'">
                      <xsl:value-of select="$localized/ft:LocText[@id='Male']" />
                    </xsl:if>
                    <xsl:if test="@IsMale = 'False'">
                      <xsl:value-of select="$localized/ft:LocText[@id='Female']" />
                    </xsl:if>
                  </xsl:if>
                  &#160;
                </td>
                <td>
                  &#160;&#160;&#160;&#160;&#160;&#160;<xsl:if test="@RankOrPoints &gt; 0">
                    <xsl:value-of select="@RankOrPoints" />
                  </xsl:if>
                </td>
              </tr>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>

  <!-- Template to render fencers by country -->
  <xsl:template name="RenderFencersByCountry">
    <xsl:param name="fencers" />
    
    <table class="dataTable">
      <!-- Table header row -->
      <tr class="dataTableHeaderRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Rank']" /></th>
      </tr>

      <!-- Fencer rows -->
      <xsl:for-each select="$fencers/ft:Fencer">
        <tr>
          <xsl:choose>
            <xsl:when test="position() mod 2 = 1">
              <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
            </xsl:when>
          </xsl:choose>

          <td>
            <xsl:if test="@Country != ''">
              <span class="flag flag{@Country}"><xsl:comment> </xsl:comment></span>
            </xsl:if>
            <xsl:value-of select="@Country" />
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          <td>
            <xsl:value-of select="@Name" />
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          <td>
            <xsl:value-of select="@Rank" />
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Template to render preliminary or round seeding -->
  <xsl:template name="RenderSeeding">
    <xsl:param name="seeding"  />
    <xsl:param name="roundNum" />
    <xsl:param name="evType"   />

    <table class="dataTable">
      <!-- Table header row -->
      <tr class="dataTableHeaderRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Seed']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <xsl:if test="$seeding/*/@Rating">
          <th><xsl:value-of select="$localized/ft:LocText[@id='ClassRank']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@TeamPoints">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Points']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@TeamRank">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Rank']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@Members">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Members']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@Club">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Clubs']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@Division">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Division']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@Country">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th>
        </xsl:if>
        <xsl:if test="$seeding/*/@V">
          <th>V</th>
          <th>V/M</th>
          <th><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></th>
          <th><xsl:value-of select="$localized/ft:LocText[@id='TR']" /></th>
          <th>Ind</th>
        </xsl:if>       
        <xsl:if test="$roundNum &gt; 0">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Status']" /></th>
        </xsl:if>
      </tr>

      <!-- Competitor rows -->
      <xsl:for-each select="$seeding/ft:Competitor">
        <tr>
          <xsl:choose>
            <xsl:when test="@Excluded">
              <xsl:attribute name="class">dataTableExcludedRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 1">
              <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          
          <td>
            <xsl:value-of select="@Seed" />
          </td>
          
          <td>
            <xsl:choose>
              <xsl:when test="@Excluded and $evType = 'Team'"><xsl:value-of select="$localized/ft:LocText[@id='TeamExcluded']" /></xsl:when>
              <xsl:when test="@Excluded and $evType = 'Individual'"><xsl:value-of select="$localized/ft:LocText[@id='FencerExcluded']" /></xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Name" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <xsl:if test="$seeding/*/@Rating">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Rating" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@TeamPoints">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@TeamPoints" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$seeding/*/@TeamRank">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@TeamRank" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@Members">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Members" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@Club">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Club" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@Division">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Division" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@Country">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:if test="@Country != ''">
                  <span class="flag flag{@Country}"><xsl:comment> </xsl:comment></span>
                </xsl:if>
                <xsl:value-of select="@Country" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$seeding/*/@V">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@V" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@VM" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@TS" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@TR" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
            <td>
              <xsl:if test="not(@Excluded) ">
                <xsl:value-of select="@Ind" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$roundNum &gt; 0">
            <td>
              <xsl:choose>
                <xsl:when test="@Exempt">
                  <span class="statusAdvanced"><xsl:value-of select="$localized/ft:LocText[@id='Exempt']" /></span>
                </xsl:when>
                <xsl:when test="@Excluded">
                  <span class="statusElim"><xsl:value-of select="$localized/ft:LocText[@id='Excluded']" /></span>
                </xsl:when>
                <xsl:when test="@Eliminated">
                  <span class="statusElim"><xsl:value-of select="$localized/ft:LocText[@id='Eliminated']" /></span>
                </xsl:when>
                <xsl:when test="$roundNum &gt; 1">
                  <span class="statusAdvanced"><xsl:value-of select="$localized/ft:LocText[@id='Advanced']" /></span>
                </xsl:when>
              </xsl:choose>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Template to render strip assignments by name in multiple columns -->
  <xsl:template name="RenderStripAssignmentsByName">
    <xsl:param name="comps" />
    
    <table class="dataTable">
      <!-- Table header row -->
      <tr class="dataTableHeaderRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <xsl:if test="$comps/*/@Pool">
          <th><xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /></th>
        </xsl:if>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Strip']" /></th>
        <xsl:if test="$comps/*/@Time">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Time']" /></th>
        </xsl:if>
      </tr>

      <!-- Competitor rows -->
      <xsl:for-each select="$comps/ft:Competitor">
        <xsl:sort select="@Name" />
        <tr>
          <xsl:choose>
            <xsl:when test="position() mod 2 = 1">
              <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
            </xsl:when>
          </xsl:choose>

          <td>
            <xsl:value-of select="@Name" />
          </td>
          
          <xsl:if test="$comps/*/@Pool">
            <td>
              <xsl:if test="@Pool != ''">
                <xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /><xsl:value-of select="@Pool" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <td>
            <xsl:if test="@Strip != ''">
              <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />&#160;<xsl:value-of select="@Strip" />
            </xsl:if>
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          
          <xsl:if test="$comps/*/@Time">
            <td>
              <xsl:value-of select="@Time" />
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Template to render strip assignments by club in multiple columns -->
  <xsl:template name="RenderStripAssignmentsByClub">
    <xsl:param name="comps" />
    
    <table class="dataTable">
      <!-- Table header row -->
      <tr class="dataTableHeaderRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Club']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <xsl:if test="$comps/*/@Pool">
          <th><xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /></th>
        </xsl:if>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Strip']" /></th>
        <xsl:if test="$comps/*/@Time">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Time']" /></th>
        </xsl:if>
      </tr>

      <!-- Competitor rows -->
      <xsl:for-each select="$comps/ft:Competitor">
        <xsl:sort select="string-length(@Club) = 0" />
        <xsl:sort select="@Club" />
        <xsl:sort select="@Name" />
        
        <tr>
          <xsl:choose>
            <xsl:when test="position() mod 2 = 1">
              <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
            </xsl:when>
          </xsl:choose>

          <td>
            <xsl:value-of select="@Club" />
          </td>
          <td>
            <xsl:value-of select="@Name" />
          </td>
          
          <xsl:if test="$comps/*/@Pool">
            <td>
              <xsl:if test="@Pool != ''">
                <xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /><xsl:value-of select="@Pool" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <td>
            <xsl:if test="@Strip != ''">
              <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />&#160;<xsl:value-of select="@Strip" />
            </xsl:if>
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          
          <xsl:if test="$comps/*/@Time">
            <td>
              <xsl:value-of select="@Time" />
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
  <!-- Template to render results (final and so far) -->
  <xsl:template name="RenderResults">
    <xsl:param name="results" />
    <xsl:param name="evType"  />
    
    <table class="dataTable">
      <!-- Table header row -->
      <tr class="dataTableHeaderRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Place']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <xsl:if test="$results/*/@Club">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Clubs']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Division">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Division']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Country">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Rating">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Class']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Earned">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Earned']" /><sup>*</sup></th>
        </xsl:if>
        <xsl:if test="$results/*/@Members">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Members']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Qualified">
          <th><xsl:value-of select="$localized/ft:LocText[@id='QualFor']" /></th>
        </xsl:if>
      </tr>
    
      <xsl:for-each select="$results/ft:Result">
        <tr>
          <xsl:choose>
            <xsl:when test="@Excluded">
              <xsl:attribute name="class">dataTableExcludedRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="@Place='1' or @Place='1T'">
              <xsl:attribute name="class">dataTableGoldResultRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="@Place='2' or @Place='2T'">
              <xsl:attribute name="class">dataTableSilverResultRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="@Place='3' or @Place='3T'">
              <xsl:attribute name="class">dataTableBronzeResultRow</xsl:attribute>
            </xsl:when>            
            <xsl:when test="position() mod 2 = 1">
              <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          
          <td>
            <xsl:value-of select="@Place" />
          </td>
          
          <td>
            <xsl:choose>
              <xsl:when test="@Excluded and $evType = 'Team'"><xsl:value-of select="$localized/ft:LocText[@id='TeamExcluded']" /></xsl:when>
              <xsl:when test="@Excluded and $evType = 'Individual'"><xsl:value-of select="$localized/ft:LocText[@id='FencerExcluded']" /></xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Name" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          
          <xsl:if test="$results/*/@Club">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Club" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@Division">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Division" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@Country">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:if test="@Country != ''">
                  <span class="flag flag{@Country}"><xsl:comment> </xsl:comment></span>
                </xsl:if>
                <xsl:value-of select="@Country" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@Rating">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Rating" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$results/*/@Earned">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Earned" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$results/*/@Members">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Members" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>

          <xsl:if test="$results/*/@Qualified">
            <td>
              <xsl:if test="not(@Excluded)">
                <xsl:value-of select="@Qualified" />
              </xsl:if>
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>
  
  <!-- Template to render temp pool results -->
  <xsl:template name="RenderTempPoolResults">
    <xsl:param name="results" />
    
    <table class="dataTable">
      <tr class="dataTableHeaderRow">
        <th><xsl:value-of select="$localized/ft:LocText[@id='Place']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Name']" /></th>
        <xsl:if test="$results/*/@Club">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Clubs']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Division">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Division']" /></th>
        </xsl:if>
        <xsl:if test="$results/*/@Country">
          <th><xsl:value-of select="$localized/ft:LocText[@id='Country']" /></th>
        </xsl:if>
        <th>V</th>
        <th>V/M</th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='TR']" /></th>
        <th>Ind</th>
        <th><xsl:value-of select="$localized/ft:LocText[@id='Status']" /></th>
      </tr>

      <xsl:for-each select="$results/ft:TempResult">
        <tr>
          <xsl:choose>
            <xsl:when test="position() mod 2 = 1">
              <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
            </xsl:when>
            <xsl:when test="position() mod 2 = 0">
              <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
            </xsl:when>
          </xsl:choose>

          <td>
            <xsl:value-of select="@Place" />
          </td>

          <td>
            <xsl:value-of select="@Name" />
          </td>
          
          <xsl:if test="$results/*/@Club">
            <td>
              <xsl:value-of select="@Club" />
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@Division">
            <td>
              <xsl:value-of select="@Division" />
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <xsl:if test="$results/*/@Country">
            <td>
              <xsl:if test="@Country != ''">
                <span class="flag flag{@Country}"><xsl:comment> </xsl:comment></span>
              </xsl:if>
              <xsl:value-of select="@Country" />
              <xsl:text xml:space="preserve">&#160;</xsl:text>
            </td>
          </xsl:if>
          
          <td>
            <xsl:value-of select="@V" />
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          <td>
            <xsl:value-of select="@VM" />
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          <td>
            <xsl:value-of select="@TS" />
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          <td>
            <xsl:value-of select="@TR" />
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          <td>
            <xsl:value-of select="@Ind" />
            <xsl:text xml:space="preserve">&#160;</xsl:text>
          </td>
          
          <td>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="@Prediction = 'CertainPromotion'">tempResultsPromoted</xsl:when>
                <xsl:when test="@Prediction = 'LikelyPromotion'">tempResultsPromoted</xsl:when>
                <xsl:when test="@Prediction = 'PossiblePromotion'">tempResultsUncertain</xsl:when>
                <xsl:when test="@Prediction = 'PossibleElimination'">tempResultsUncertain</xsl:when>
                <xsl:when test="@Prediction = 'LikelyElimination'">tempResultsEliminated</xsl:when>
              </xsl:choose>
            </xsl:attribute>
            <xsl:variable name="status" select="@Prediction" />
            <xsl:value-of select="$localized/ft:LocText[@id=$status]" />
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Template to render team match scores -->
  <xsl:template name="RenderTeamMatch">
    <xsl:param name="isPool" />
    
    <div class="teamMatch">
      <a name="teamMatch{@ID}" class="teamMatchName">
        <xsl:value-of select="ft:MatchName" />
      </a>
      
      <xsl:choose>
        <xsl:when test="@Type='DiscreteBout'">
          <table class="dataTable">
            <tr class="dataTableHeaderRow">
              <td class="teamMatchNumCol">#</td>
              <td class="teamMatchNameCol"><xsl:value-of select="ft:TeamNameLeft"/></td>
              <td class="teamMatchScoreCol"><xsl:value-of select="$localized/ft:LocText[@id='Score']" /></td>
              <td class="teamMatchScoreCol"><xsl:value-of select="$localized/ft:LocText[@id='Score']" /></td>
              <td class="teamMatchNameCol"><xsl:value-of select="ft:TeamNameRight"/></td>
              <td class="teamMatchNumCol">#</td>
            </tr>
          
            <xsl:for-each select="ft:Encounters/ft:Encounter">
              <tr>
                <xsl:choose>
                  <xsl:when test="position() mod 2 = 1">
                    <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="position() mod 2 = 0">
                    <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
                  </xsl:when>
                </xsl:choose>
              
                <td class="teamMatchNumCol">
                  <xsl:value-of select="ft:FencerNumLeft"/>
                </td>
                <td class="teamMatchNameCol">
                  <xsl:value-of select="ft:FencerNameLeft"/>
                </td>

                <xsl:if test="../../../@AnyWDX = 'True'">
                  <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                  <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                </xsl:if>
                
                <xsl:if test="../../../@AnyWDX != 'True'">
                  <td class="teamMatchScoreCol">
                    <xsl:value-of select="ft:BoutScoreLeft"/>
                  </td>
                  <td class="teamMatchScoreCol">
                    <xsl:value-of select="ft:BoutScoreRight"/>
                  </td>
                </xsl:if>
                  
                <td class="teamMatchNameCol">
                  <xsl:value-of select="ft:FencerNameRight"/>
                </td>
                <td class="teamMatchNumCol">
                  <xsl:value-of select="ft:FencerNumRight"/>
                </td>
              </tr>
            </xsl:for-each>
            
            <tr class="dataTableHeaderRow">
              <td class="teamMatchNumCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNameCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              
              <xsl:if test="../@AnyWDX= 'True'">
                <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              </xsl:if>
              
              <xsl:if test="../@AnyWDX != 'True'">
                <td class="teamMatchScoreCol">
                  <xsl:value-of select="ft:FinalScoreLeft" />
                </td>
                <td class="teamMatchScoreCol">
                  <xsl:value-of select="ft:FinalScoreRight" />
                </td>
              </xsl:if>

              <td class="teamMatchNameCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNumCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
            </tr>
            
          </table>
      
        </xsl:when>
        <xsl:otherwise>
          <table class="dataTable">
            <tr class="dataTableHeaderRow">
              <td class="teamMatchNumCol">#</td>
              <td class="teamMatchNameCol"><xsl:value-of select="ft:TeamNameLeft"/></td>
              <td class="teamMatchTouchesCol"><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></td>
              <td class="teamMatchScoreCol"><xsl:value-of select="$localized/ft:LocText[@id='Score']" /></td>
              <td class="teamMatchScoreCol"><xsl:value-of select="$localized/ft:LocText[@id='Score']" /></td>
              <td class="teamMatchTouchesCol"><xsl:value-of select="$localized/ft:LocText[@id='TS']" /></td>
              <td class="teamMatchNameCol"><xsl:value-of select="ft:TeamNameRight"/></td>
              <td class="teamMatchNumCol">#</td>
            </tr>
          
            <xsl:for-each select="ft:Encounters/ft:Encounter">
              <tr>
                <xsl:choose>
                  <xsl:when test="position() mod 2 = 1">
                    <xsl:attribute name="class">dataTableOddRow</xsl:attribute>
                  </xsl:when>
                  <xsl:when test="position() mod 2 = 0">
                    <xsl:attribute name="class">dataTableEvenRow</xsl:attribute>
                  </xsl:when>
                </xsl:choose>
              
                <td class="teamMatchNumCol">
                  <xsl:value-of select="ft:FencerNumLeft"/>
                </td>
                <td class="teamMatchNameCol">
                  <xsl:value-of select="ft:FencerNameLeft"/>
                </td>

                <xsl:if test="../../../@AnyWDX = 'True'">
                  <td class="teamMatchTouchesCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                  <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                  <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                  <td class="teamMatchTouchesCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                </xsl:if>
                
                <xsl:if test="$isPool = 'True' or ../../../@AnyWDX != 'True'">
                  <td class="teamMatchTouchesCol">
                    <xsl:value-of select="ft:TouchesLeft"/>
                  </td>
                  <td class="teamMatchScoreCol">
                    <xsl:value-of select="ft:ScoreLeft"/>
                  </td>
                  <td class="teamMatchScoreCol">
                    <xsl:value-of select="ft:ScoreRight"/>
                  </td>
                  <td class="teamMatchTouchesCol">
                    <xsl:value-of select="ft:TouchesRight"/>
                  </td>
                </xsl:if>
                  
                <td class="teamMatchNameCol">
                  <xsl:value-of select="ft:FencerNameRight"/>
                </td>
                <td class="teamMatchNumCol">
                  <xsl:value-of select="ft:FencerNumRight"/>
                </td>
              </tr>
            </xsl:for-each>
            
            <tr class="dataTableHeaderRow">
              <td class="teamMatchNumCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNameCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchTouchesCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              
              <xsl:if test="../@AnyWDX = 'True'">
                <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
                <td class="teamMatchScoreCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              </xsl:if>
              
              <xsl:if test="$isPool = 'True' or ../@AnyWDX != 'True'">
                <td class="teamMatchScoreCol">
                  <xsl:value-of select="ft:FinalScoreLeft" />
                </td>
                <td class="teamMatchScoreCol">
                  <xsl:value-of select="ft:FinalScoreRight" />
                </td>
              </xsl:if>

              <td class="teamMatchTouchesCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNameCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
              <td class="teamMatchNumCol"><xsl:text xml:space="preserve">&#160;</xsl:text></td>
            </tr>
          </table>
        </xsl:otherwise>
      </xsl:choose>

      <!-- Match referees, if any -->
      <xsl:if test="ft:Referee1 or ft:Referee2 or ft:Referee3 or ft:Referee4">
        <div class="teamMatchRefs">
          <span class="tableauReferee">
            <xsl:if test="ft:Referee1">
              <xsl:call-template name="RenderReferee">
                <xsl:with-param name="referee"  select="ft:Referee1" />
                <xsl:with-param name="isVideo"  select="false()" />
                <xsl:with-param name="isAssist" select="false()" />
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="ft:Referee2">
              <xsl:if test="ft:Referee1"><br /></xsl:if>
              <xsl:call-template name="RenderReferee">
                <xsl:with-param name="referee"  select="ft:Referee2" />
                <xsl:with-param name="isVideo"  select="false()" />
                <xsl:with-param name="isAssist" select="false()" />
              </xsl:call-template>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="@Type='SixWeapon'">
                <xsl:if test="ft:Referee3">
                  <xsl:if test="ft:Referee1 or ft:Referee2"><br /></xsl:if>
                  <xsl:call-template name="RenderReferee">
                    <xsl:with-param name="referee"  select="ft:Referee3" />
                    <xsl:with-param name="isVideo"  select="false()" />
                    <xsl:with-param name="isAssist" select="false()" />
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="ft:Referee4">
                  <xsl:if test="ft:Referee1 or ft:Referee2 or ft:Referee3"><br /></xsl:if>
                  <xsl:call-template name="RenderReferee">
                    <xsl:with-param name="referee"  select="ft:Referee4" />
                    <xsl:with-param name="isVideo"  select="true()" />
                    <xsl:with-param name="isAssist" select="false()" />
                  </xsl:call-template>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="ft:Referee3">
                  <xsl:if test="ft:Referee1 or ft:Referee2"><br /></xsl:if>
                  <xsl:call-template name="RenderReferee">
                    <xsl:with-param name="referee"  select="ft:Referee3" />
                    <xsl:with-param name="isVideo"  select="false()" />
                    <xsl:with-param name="isAssist" select="true()" />
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="ft:Referee4">
                  <xsl:if test="ft:Referee1 or ft:Referee2 or ft:Referee3"><br /></xsl:if>
                  <xsl:call-template name="RenderReferee">
                    <xsl:with-param name="referee"  select="ft:Referee4" />
                    <xsl:with-param name="isVideo"  select="false()" />
                    <xsl:with-param name="isAssist" select="true()" />
                  </xsl:call-template>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>
          </span>
        </div>
      </xsl:if>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
