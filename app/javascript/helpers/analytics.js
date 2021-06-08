import VueAnalytics from 'vue-analytics'

export const addAnalyticsEvents = () => {
  const downloadLinks = document.querySelectorAll('a[download][data-download-type][data-download-label]')

  Array.prototype.forEach.call(
    downloadLinks,
    el => {
      el.addEventListener('click', getOnDownloadClick(1))
      el.addEventListener('contextmenu', getOnDownloadClick(0))
    }
  )
}

const getOnDownloadClick = intent => event => {
  const el = event.target
  const downloadType = el.getAttribute('data-download-type')
  const downloadLabel = el.getAttribute('data-download-label')

  // eslint-disable-next-line no-undef
  gtag('event', 'download', {
    event_category: downloadType,
    event_label: downloadLabel,
    value: intent
  })
}

export const trackPageView = event => {
  //gtag defined in _google_analytics.html.erb
  if (typeof gtag === 'function') {
    // eslint-disable-next-line no-undef
    gtag('event', 'page_view', {
      page_location: event.data.url,
    })
  }
}

export const initVueAnalytics = vue => {
  if (window.ENABLE_ANALYTICS) {
    vue.use(VueAnalytics, {
      id: 'UA-129191439-1',
      checkDuplicatedScript: true
    })
  }
}