{% if page.comments %}
  <div class="comments" id="comments">
    {% if (theme.duoshuo and theme.duoshuo.shortname) or theme.duoshuo_shortname %}
      <div class="ds-thread" data-thread-key="{{ page.path }}"
           data-title="{{ page.title }}" data-url="{{ page.permalink }}">
      </div>
    {% elseif theme.disqus_shortname %}
      <div id="disqus_thread">
        <noscript>
          Please enable JavaScript to view the
          <a href="//disqus.com/?ref_noscript">comments powered by Disqus.</a>
        </noscript>
      </div>
    {% elseif theme.youyan_uid %}
        <div id="uyan_frame"></div>
    {% else %}
      <!-- 评论 start 写死的 -->
      <div id="hypercomments_widget"></div>
      <script type="text/javascript">
      _hcwp = window._hcwp || [];
      _hcwp.push({widget:"Stream", widget_id: 92211});
      (function() {
      if("HC_LOAD_INIT" in window)return;
      HC_LOAD_INIT = true;
      var lang = (navigator.language || navigator.systemLanguage || navigator.userLanguage || "en").substr(0, 2).toLowerCase();
      var hcc = document.createElement("script"); hcc.type = "text/javascript"; hcc.async = true;
      hcc.src = ("https:" == document.location.protocol ? "https" : "http")+"://w.hypercomments.com/widget/hc/92211/"+lang+"/widget.js";
      var s = document.getElementsByTagName("script")[0];
      s.parentNode.insertBefore(hcc, s.nextSibling);
      })();
      </script>
      <a href="http://hypercomments.com" rel = "nofollow" class="hc-link" title="comments widget">comments powered by HyperComments</a>
      <!-- 评论 end -->
    {% endif %}
  </div>
{% endif %}


