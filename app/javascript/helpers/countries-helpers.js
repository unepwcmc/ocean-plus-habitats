export const UNDEFINED_ID = '__UNDEFINED__'

export const UNDEFINED_SELECTIONS = {
  sector: UNDEFINED_ID,
  sub_industry: UNDEFINED_ID,
  production_process: []
}

export const EXPLORE_FILTERS = [
  {
    id: 'sector',
    optionsId: 'sectors',
    parentId: null,
    isMultiple: false
  },
  {
    id: 'sub_industry',
    optionsId: 'sub_industries',
    parentId: 'sector',
    isMultiple: false
  },
  {
    id: 'production_process',
    optionsId: 'production_processes',
    parentId: 'sub_industry',
    isMultiple: true
  }
]

export const getCategories = services => {
  let count = 1
  const categories = []

  services.forEach(service => {
    const category = categories.find(
      category => category.name === service.category
    )

    if (category) {
      category.services.push(service)
    } else {
      const newCategory = {
        id: count++,
        name: service.category,
        services: [service]
      }

      categories.push(newCategory)
    }
  })

  return categories.sort(compareAlphabeticallyBy('name'))
}

export const compareAlphabeticallyBy = key => (a, b) => {
  if(a[key] < b[key]) { return -1 }
  if(a[key] > b[key]) { return 1 }

  return 0
}

export const getSubIndustriesFromSectors = sectors => {
  const subIndustries = new Set()

  sectors.forEach(sector => {
    sector.sub_industries.forEach( sub_industry => {
      subIndustries.add(sub_industry)
    })
  })

  //avoid spread operator as Array.prototype.from is not supported by IE
  const subIndustriesArray = []

  subIndustries.forEach(el => subIndustriesArray.push(el))

  return subIndustriesArray.sort(compareAlphabeticallyBy('name'))
}

export const getServicesCountFromCategories = categories => {
  let count = 0

  categories.forEach(category => {
    count += category.services.length
  })

  return count
}

export const getAssetCountFromVisibilitiesById = visibilitiesById => {
  let count = 0

  for(const assetId in visibilitiesById) {
    if(visibilitiesById[assetId]) {
      count += 1
    }
  }

  return count
}

export const resetDependentSelections = (state, changedDropdownId) => {
  let isChanged = false

  state.filters.forEach(filter => {
    if (isChanged === true) {
      state.selections[filter.id] = filter.isMultiple
        ? []
        : UNDEFINED_ID
    } else if (filter.id === changedDropdownId) {
      isChanged = true
    }
  })
}
