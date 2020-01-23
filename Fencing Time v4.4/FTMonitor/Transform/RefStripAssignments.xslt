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

  <xsl:variable name="localized" select="document(concat('Lang\', $langCode, '.xml'))/ft:LocalizedText" />

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <link rel="stylesheet" type="text/css" href="{$localPath}/Styles/default.css" />
      </head>

      <body class="{$bgClass}" style="font-size: {$fontSize}em;">
        <div class="page">
          <h2><xsl:value-of select="$localized/ft:LocText[@id='RefStripAssignments']" /></h2>

          <div>
              <table class="dataTable">
                <tr class="headerRow">
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Name']" />
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Time']" />
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Role']" />
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Event']" />
                  </th>
                  <th>
                    <xsl:value-of select="$localized/ft:LocText[@id='Assignment']" />
                  </th>
                </tr>

                <xsl:for-each select="/ArrayOfRefStripAssignmentViewModel/RefStripAssignmentViewModel">
                  <tr>
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="position() mod 2 = 0">evenRow</xsl:when>
                        <xsl:otherwise>oddRow</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>

                    <td>
                      <xsl:value-of select="RefName" />
                    </td>

                    <td>
                      <xsl:if test="StripNum != ''">
                        <xsl:value-of select="$localized/ft:LocText[@id='Strip']" />&#160;
                        <xsl:value-of select="StripNum" />
                      </xsl:if>
                    </td>

                    <td>
                      <xsl:call-template name="FormatTime">
                        <xsl:with-param name="time" select="substring-after(StartTime, 'T')" />
                        <xsl:with-param name="lang" select="$langCode" />
                      </xsl:call-template>
                    </td>

                    <td>
                      <xsl:choose>
                        <xsl:when test="Video = 'true'"><xsl:value-of select="$localized/ft:LocText[@id='video']" /></xsl:when>
                        <xsl:when test="Assist = 'true'"><xsl:value-of select="$localized/ft:LocText[@id='assist']" /></xsl:when>
                        <xsl:otherwise><xsl:value-of select="$localized/ft:LocText[@id='ref']" /></xsl:otherwise>
                      </xsl:choose>
                    </td>
                    
                    <td>
                      <xsl:value-of select="EventName" />
                    </td>

                    <td>
                      <xsl:if test="PoolNum != '0'">
                        <xsl:value-of select="$localized/ft:LocText[@id='PoolNum']" /><xsl:value-of select="PoolNum" />
                      </xsl:if>
                      <xsl:if test="PoolNum = '0'">
                        <xsl:value-of select="TableName" />:&#160;&#160;&#160;<xsl:value-of select="Comp1Name" /> vs. <xsl:value-of select="Comp2Name" />
                      </xsl:if>                      
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
