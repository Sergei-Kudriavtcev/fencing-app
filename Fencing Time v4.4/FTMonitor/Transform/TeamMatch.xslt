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
  <xsl:param name="screenWidth"  />
  <xsl:param name="screenHeight" />
  <xsl:param name="swapSides"    />

  <xsl:variable name="localized" select="document(concat('Lang\', $langCode, '.xml'))/ft:LocalizedText" />
  
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link rel="stylesheet" type="text/css" href="{$localPath}/Styles/default.css" />
      </head>

      <body class="{$bgClass}" style="font-size: {$fontSize}em;">
        <xsl:variable name="rowHeight" select="number($screenHeight) div 12" />
        <div class="page">
          <div class="twoColumns">
            
            <div class="leftColumn">
              <div class="teamName">
                <xsl:variable name="leftID">
                  <xsl:choose>
                    <xsl:when test="$swapSides = 'true'">
                      <xsl:value-of select="/TeamMatchInfo/Match/TeamRightID" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="/TeamMatchInfo/Match/TeamLeftID" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>   
                <xsl:variable name="leftComp" select="/TeamMatchInfo/Bout/*[ID=$leftID]" />
                <xsl:value-of select="$leftComp/Name" />
              </div>
              
              <table class="teamTable">
                <tr class="teamHeaderRow">
                  <th style="width: 5%;">#</th>
                  <th style="width: 65%;">
                    <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                  </th>
                  <th style="width: 15%;">
                    <xsl:value-of select="$localized/ft:LocText[@id='Touches']" />
                  </th>
                  <th style="width: 15%;">
                    <xsl:value-of select="$localized/ft:LocText[@id='Score']" />
                  </th>
                </tr>

                <xsl:for-each select="/TeamMatchInfo/Match/Encounters/TeamEncounter">
                  <tr style="height: {$rowHeight}px">
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                        <xsl:otherwise>oddRow</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>

                    <td>
                      <xsl:choose>
                        <xsl:when test="$swapSides = 'true'">
                          <xsl:value-of select="PositionRight" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="PositionLeft" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <td class="teamFencer" style="max-width: 65%;">
                      <xsl:choose>
                        <xsl:when test="$swapSides = 'true'">
                          <xsl:value-of select="FencerNameRight" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="FencerNameLeft" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <td>
                      <xsl:choose>
                        <xsl:when test="$swapSides = 'true'">
                          <xsl:if test="ScoreRight != -1">
                            <xsl:if test="position() = 1">
                              <xsl:value-of select="ScoreRight"/>
                            </xsl:if>
                            <xsl:if test="position() != 1">
                              <xsl:variable name="prevPos" select="position()-1" />
                              <xsl:value-of select="number(ScoreRight) - number(../TeamEncounter[$prevPos]/ScoreRight)"/>
                            </xsl:if>
                          </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="ScoreLeft != -1">
                            <xsl:if test="position() = 1">
                              <xsl:value-of select="ScoreLeft"/>
                            </xsl:if>
                            <xsl:if test="position() != 1">
                              <xsl:variable name="prevPos" select="position()-1" />
                              <xsl:value-of select="number(ScoreLeft) - number(../TeamEncounter[$prevPos]/ScoreLeft)"/>
                            </xsl:if>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <td>
                      <xsl:choose>
                        <xsl:when test="$swapSides = 'true'">
                          <xsl:if test="ScoreRight != -1">
                            <xsl:value-of select="ScoreRight" />
                          </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="ScoreLeft != -1">
                            <xsl:value-of select="ScoreLeft" />
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </div>

            <div class="rightColumn">
              <div class="teamName">
                <xsl:variable name="rightID">
                  <xsl:choose>
                    <xsl:when test="$swapSides = 'true'">
                      <xsl:value-of select="/TeamMatchInfo/Match/TeamLeftID" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="/TeamMatchInfo/Match/TeamRightID" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rightComp" select="/TeamMatchInfo/Bout/*[ID=$rightID]" />
                <xsl:value-of select="$rightComp/Name" />
              </div>

              <table class="teamTable">
                <tr class="teamHeaderRow">
                  <th style="width: 15%;">
                    <xsl:value-of select="$localized/ft:LocText[@id='Score']" />
                  </th>
                  <th style="width: 15%;">
                    <xsl:value-of select="$localized/ft:LocText[@id='Touches']" />
                  </th>
                  <th style="width: 65%;">
                    <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                  </th>
                  <th style="width: 5%;">#</th>
                </tr>

                <xsl:for-each select="/TeamMatchInfo/Match/Encounters/TeamEncounter">
                  <tr style="height: {$rowHeight}px">
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                        <xsl:otherwise>oddRow</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>

                    <td>
                      <xsl:choose>
                        <xsl:when test="$swapSides = 'true'">
                          <xsl:if test="ScoreLeft != -1">
                            <xsl:value-of select="ScoreLeft" />
                          </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="ScoreRight != -1">
                            <xsl:value-of select="ScoreRight" />
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <td>
                      <xsl:choose>
                        <xsl:when test="$swapSides = 'true'">
                          <xsl:if test="ScoreLeft != -1">
                            <xsl:if test="position() = 1">
                              <xsl:value-of select="ScoreLeft"/>
                            </xsl:if>
                            <xsl:if test="position() != 1">
                              <xsl:variable name="prevPos" select="position()-1" />
                              <xsl:value-of select="number(ScoreLeft) - number(../TeamEncounter[$prevPos]/ScoreLeft)"/>
                            </xsl:if>
                          </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="ScoreRight != -1">
                            <xsl:if test="position() = 1">
                              <xsl:value-of select="ScoreRight"/>
                            </xsl:if>
                            <xsl:if test="position() != 1">
                              <xsl:variable name="prevPos" select="position()-1" />
                              <xsl:value-of select="number(ScoreRight) - number(../TeamEncounter[$prevPos]/ScoreRight)"/>
                            </xsl:if>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <td class="teamFencer" style="max-width: 65%;">
                      <xsl:choose>
                        <xsl:when test="$swapSides = 'true'">
                          <xsl:value-of select="FencerNameLeft" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="FencerNameRight" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>

                    <td>
                      <xsl:choose>
                        <xsl:when test="$swapSides = 'true'">
                          <xsl:value-of select="PositionLeft" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="PositionRight" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </tr>
                </xsl:for-each>
              </table>
            </div>

            <xsl:if test="/TeamMatchInfo/Bout/Winner">
              <div class="teamWinner">
                <xsl:value-of select="$localized/ft:LocText[@id='Winner']" />:
                <xsl:value-of select="/TeamMatchInfo/Bout/Winner/Name"/>,
                <xsl:value-of select="/TeamMatchInfo/Bout/Score"/>
              </div>
            </xsl:if>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
