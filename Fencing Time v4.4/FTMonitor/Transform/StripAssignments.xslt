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
  <xsl:param name="fontSize"   />
  <xsl:param name="langCode"   />
  <xsl:param name="bgClass"    />

  <!-- Page-specific parameters -->
  <xsl:param name="isPool"     />
  <xsl:param name="showTimes"  />

  <xsl:variable name="localized" select="document(concat('Lang\', $langCode, '.xml'))/ft:LocalizedText" />

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link rel="stylesheet" type="text/css" href="{$localPath}/Styles/default.css" />
      </head>

      <body class="{$bgClass}" style="font-size: {$fontSize}em;">
        <div class="page">
          <xsl:variable name="allStrips" select="/ArrayOfStripAssignment/StripAssignment" />

          <h2>
            <xsl:if test="$isPool='true'">
              <xsl:value-of select="$localized/ft:LocText[@id='PoolStripAssignments']" />
            </xsl:if>
            <xsl:if test="$isPool='false'">
              <xsl:value-of select="$localized/ft:LocText[@id='ElimStripAssignments']" />
            </xsl:if>
          </h2>

          <xsl:variable name="maxRows">
            <xsl:choose>
              <xsl:when test="number($fontSize) &lt; 1.25">25</xsl:when>
              <xsl:when test="number($fontSize) &gt; 1.75">18</xsl:when>
              <xsl:otherwise >20</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="numCols">
            <xsl:choose>
              <xsl:when test="count(/ArrayOfStripAssignment/StripAssignment) > $maxRows">3</xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name="col1rows">
            <xsl:choose>
              <xsl:when test="$numCols = 3">
                <xsl:value-of select="(count(/ArrayOfStripAssignment/StripAssignment) + 2) div 3"></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="count(/ArrayOfStripAssignment/StripAssignment)"></xsl:value-of>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <div>
            <xsl:if test="$numCols = 3">
              <xsl:attribute name="class">threeColumns</xsl:attribute>
            </xsl:if>
              
            <div class="firstColumn">
              <table class="dataTable">
                <tr class="headerRow">
                  <th style="width: 50%;">
                    <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                  </th>
                  <th style="width: 25%;">
                    <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />
                  </th>
                  <xsl:if test="$showTimes = 'true' and $allStrips/StartTime[.!='']">
                    <th style="width: 25%;">
                      <xsl:value-of select="$localized/ft:LocText[@id='Time']" />
                    </th>
                  </xsl:if>
                </tr>

                <xsl:for-each select="/ArrayOfStripAssignment/StripAssignment[position() &lt;= $col1rows]">
                  <tr>
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                        <xsl:otherwise>oddRow</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>

                    <td>
                      <xsl:value-of select="Name" />
                    </td>

                    <td>
                      <xsl:if test="StripNum != ''">
                        <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />&#160;
                        <xsl:value-of select="StripNum" />
                      </xsl:if>
                      &#160;
                    </td>

                    <xsl:if test="$showTimes = 'true' and $allStrips/StartTime[.!='']">
                      <td>
                        <xsl:call-template name="FormatTime">
                          <xsl:with-param name="time" select="substring-after(StartTime, 'T')" />
                          <xsl:with-param name="lang" select="$langCode" />
                        </xsl:call-template>
                        &#160;
                      </td>
                    </xsl:if>
                  </tr>
                </xsl:for-each>
              </table>
            </div>

            <xsl:if test="$numCols = 3">
              <div class="secondColumn">
                <table class="dataTable">
                  <tr class="headerRow">
                    <th style="width: 50%;">
                      <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                    </th>
                    <th style="width: 25%;">
                      <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />
                    </th>
                    <xsl:if test="$showTimes = 'true' and $allStrips/StartTime[.!='']">
                      <th style="width: 25%;">
                        <xsl:value-of select="$localized/ft:LocText[@id='Time']" />
                      </th>
                    </xsl:if>
                  </tr>

                  <xsl:for-each select="/ArrayOfStripAssignment/StripAssignment[position() &gt; $col1rows and position() &lt;= ($col1rows * 2)]">
                    <tr>
                      <xsl:attribute name="class">
                        <xsl:choose>
                          <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                          <xsl:otherwise>oddRow</xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>

                      <td>
                        <xsl:value-of select="Name" />
                      </td>

                      <td>
                        <xsl:if test="StripNum != ''">
                          <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />&#160;
                          <xsl:value-of select="StripNum" />
                        </xsl:if>
                        &#160;
                      </td>

                      <xsl:if test="$showTimes = 'true' and $allStrips/StartTime[.!='']">
                        <td>
                          <xsl:call-template name="FormatTime">
                            <xsl:with-param name="time" select="substring-after(StartTime, 'T')" />
                            <xsl:with-param name="lang" select="$langCode" />
                          </xsl:call-template>
                          &#160;
                        </td>
                      </xsl:if>
                    </tr>
                  </xsl:for-each>
                </table>
              </div>

              <div class="thirdColumn">
                <table class="dataTable">
                  <tr class="headerRow">
                    <th style="width: 50%;">
                      <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                    </th>
                    <th style="width: 25%;">
                      <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />
                    </th>
                    <xsl:if test="$showTimes = 'true' and $allStrips/StartTime[.!='']">
                      <th style="width: 25%;">
                        <xsl:value-of select="$localized/ft:LocText[@id='Time']" />
                      </th>
                    </xsl:if>
                  </tr>

                  <xsl:for-each select="/ArrayOfStripAssignment/StripAssignment[position() &gt; ($col1rows * 2)]">
                    <tr>
                      <xsl:attribute name="class">
                        <xsl:choose>
                          <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                          <xsl:otherwise>oddRow</xsl:otherwise>
                        </xsl:choose>
                      </xsl:attribute>

                      <td>
                        <xsl:value-of select="Name" />
                      </td>

                      <td>
                        <xsl:if test="StripNum != ''">
                          <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />&#160;
                          <xsl:value-of select="StripNum" />
                        </xsl:if>
                        &#160;
                      </td>

                      <xsl:if test="$showTimes = 'true' and $allStrips/StartTime[.!='']">
                        <td>
                          <xsl:call-template name="FormatTime">
                            <xsl:with-param name="time" select="substring-after(StartTime, 'T')" />
                            <xsl:with-param name="lang" select="$langCode" />
                          </xsl:call-template>
                          &#160;
                        </td>
                      </xsl:if>
                    </tr>
                  </xsl:for-each>
                </table>
              </div>
            </xsl:if>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:include href="Transform\Common.xslt" />
</xsl:stylesheet>
