<?xml version="1.0" encoding="utf-8"?>
<!--
  Browsers stopped rendering RSS years ago: click a feed URL and you get raw
  XML. This stylesheet turns the feed into a readable page for anyone who
  arrives with a browser. Feed readers ignore it entirely, and the feed itself
  stays a plain, valid RSS 2.0 document.
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="/rss/channel/title"/> — feed</title>
        <link rel="stylesheet" href="/css/inconsolata.css"/>
        <style>
          :root { --accent: #dc3545; --accent-dark: #c82333; }
          body {
            font-family: "Inconsolata", ui-monospace, SFMono-Regular, Menlo, monospace;
            color: #2a2a2a;
            background: #fff;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem 1.15rem 4rem;
            line-height: 1.6;
          }
          a { color: var(--accent); text-decoration: none; }
          a:hover { text-decoration: underline; }
          h1 { font-size: 1.6rem; margin: 0 0 0.35rem; }
          .tagline { color: #6c757d; margin: 0 0 1.75rem; }
          .notice {
            border: 1px solid rgba(220, 53, 69, 0.18);
            border-radius: 14px;
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.04);
            padding: 1.25rem;
            margin-bottom: 2.25rem;
          }
          .notice h2 { font-size: 1.05rem; margin: 0 0 0.5rem; color: var(--accent-dark); }
          .notice p { margin: 0.4rem 0; }
          .feed-url-row {
            display: flex;
            align-items: stretch;
            gap: 0.5rem;
            margin-top: 0.75rem;
            flex-wrap: wrap;
          }
          .feed-url {
            flex: 1 1 260px;
            min-width: 0;
            background: #f7f7f7;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            padding: 0.6rem 0.8rem;
            word-break: break-all;
            font-size: 0.9rem;
          }
          .copy-btn {
            font-family: inherit;
            font-weight: 700;
            font-size: 0.85rem;
            color: var(--accent-dark);
            background: transparent;
            border: 1px solid rgba(220, 53, 69, 0.35);
            border-radius: 8px;
            padding: 0.4rem 0.95rem;
            cursor: pointer;
          }
          .copy-btn:hover { background: rgba(220, 53, 69, 0.08); }
          .item {
            border-left: 3px solid var(--accent-dark);
            border-radius: 0 8px 8px 0;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
            padding: 0.75rem 1.25rem;
            margin-bottom: 1.5rem;
          }
          .item time { display: block; font-size: 0.85rem; color: #6c757d; }
          .item h3 { margin: 0.3rem 0 0; font-size: 1.05rem; }
          .item h3 a { color: inherit; }
          .item h3 a:hover { color: var(--accent-dark); }
          .back { display: inline-block; margin-top: 1rem; font-weight: 700; }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="/rss/channel/title"/></h1>
        <p class="tagline"><xsl:value-of select="/rss/channel/description"/></p>

        <div class="notice">
          <h2>Add this address to your feed reader</h2>
          <p>You will then get lab news as it is posted, without having to check
          back. This page is an RSS feed: it is meant for a reader such as
          Feedly, Inoreader, NetNewsWire or Thunderbird, not for reading in a
          browser.</p>
          <div class="feed-url-row">
            <code class="feed-url" id="feed-url">
              <xsl:value-of select="/rss/channel/atom:link[@rel='self']/@href"/>
            </code>
            <button class="copy-btn" id="copy" type="button">copy</button>
          </div>
          <p>
            <a class="back" href="{/rss/channel/link}">← back to the site</a>
          </p>
        </div>
        <script>
          document.getElementById('copy').addEventListener('click', function () {
            var button = this;
            var el = document.getElementById('feed-url');
            function flash(label) {
              button.textContent = label;
              setTimeout(function () { button.textContent = 'copy'; }, 1500);
            }
            /* The clipboard API is refused in plenty of ordinary situations, and
               a button that silently does nothing is worse than no button, so
               fall back to selecting the address for the reader to copy. */
            function selectAddress() {
              var range = document.createRange();
              range.selectNodeContents(el);
              var sel = window.getSelection();
              sel.removeAllRanges();
              sel.addRange(range);
              flash('selected');
            }
            if (navigator.clipboard &amp;&amp; navigator.clipboard.writeText) {
              navigator.clipboard.writeText(el.textContent.trim()).then(
                function () { flash('copied'); },
                selectAddress
              );
            } else {
              selectAddress();
            }
          });
        </script>

        <xsl:for-each select="/rss/channel/item">
          <div class="item">
            <time><xsl:value-of select="substring(pubDate, 1, 16)"/></time>
            <h3>
              <a href="{link}"><xsl:value-of select="title"/></a>
            </h3>
          </div>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
