import { isTabForward, isTabBackward } from '../helpers/focus-helpers'
import { KEYCODES } from '../helpers/keyboard-helpers'

import mixinPopupCloseListeners from './mixin-popup-close-listeners'


export default {
  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeSelect', clickAreaSelector: '.v-select__click-area'}),
  ],

  data () {
    return {
      isActive: false,
      highlightedOptionIndex: -1,
      searchTerm: '',
      dropdownId: 'v-select-dropdown-' + this.config.id,
      dropdownOptionsName: 'v-select-dropdown-input' + this.config.id,
      toggleId: 'v-select-toggle-' + this.config.id,
      searchId: 'v-select-search-' + this.config.id,
      searchResetId: 'v-select-search-reset-' + this.config.id
    }
  },

  computed: {
    hasKeyboardFocus () {
      return this.highlightedOptionIndex >= 0
    },

    highlightedOptionId () {
      if (this.isActive && this.filteredOptions.length && this.hasKeyboardFocus) {
        return this.getOptionInputId(this.filteredOptions[this.highlightedOptionIndex])
      }

      return null
    },

    isDisabled () {
      return !this.options.length
    },

    getPlaceholderText () {
      return this.config.placeholder || ''
    },

    showOptions () {
      return this.isActive && Boolean(this.filteredOptions.length)
    },

    showResetIcon () {
      return this.searchTerm && this.isActive
    },

    showSearchIcon () {
      return this.hasSearchIcon && !this.showResetIcon
    },

    container () {
      return this.$el.querySelector('#' + this.dropdownId)
    }
  },

  watch: {
    searchTerm () {
      this.resetHighlightedIndex()
    },

    highlightedOptionId (id) {
      if (id !== null) {
        this.scrollToHighlightedOption()
      }
    }
  },

  created () {
    this.initializeSelectedInternal()
  },

  mounted () {
    this.addTabFromSearchListener()
    this.addArrowKeyListeners()
    this.addTabForwardFromResetListener()
  },

  methods: {
    toggleSelect (e) {
      if (this.options.length && !this.isActive) {
        this.openSelect(e)
      } else {
        this.closeSelect(e)
      }
    },

    isHighlighted (index) {
      return index === this.highlightedOptionIndex
    },

    resetHighlightedIndex() {
      this.highlightedOptionIndex = -1
    },

    getOptionFromId (id) {
      const filteredOptions = this.options.filter( option => {
        return option.id === id
      })

      return filteredOptions.length ? filteredOptions[0] : null
    },

    getOptionInputId (option) {
      const friendlyId = option.id.toString().replace(/[ ()]/g, '-')

      return `option-${this.config.id}-${friendlyId}`
    },

    matchesSearchTerm (option) {
      const regex = new RegExp(`${this.searchTerm}`, 'i')
      const match = option.name.toString().match(regex)

      return !this.searchTerm || match
    },

    emitSelection () {
      this.$emit('update:selected-option', this.selectedInternal)
    },

    resetSearchTermClick () {
      this.resetSearchTerm()
      this.focusSearch()
    },

    resetSearchTerm () {
      this.searchTerm = ''
    },

    scrollToHighlightedOption () {
      const highlightedOption = this.$el.querySelector('#' + this.highlightedOptionId)

      this.container.scrollTop = highlightedOption.offsetTop
    },

    conditionalOptionClasses (option, index) {
      return {
        'highlighted': this.isHighlighted(index),
        'selected': this.isSelected(option)
      }
    },

    addTabFromSearchListener () {
      this.$el.querySelector('#' + this.searchId).addEventListener('keydown', e => {
        if (isTabBackward(e)) {
          this.closeSelect()
        } else if (isTabForward(e) && !this.showResetIcon) {
          this.closeSelect()
        }
      })
    },

    addTabForwardFromResetListener () {
      this.$el.querySelector('#' + this.searchResetId).addEventListener('keydown', e => {
        if (isTabForward(e)) {
          this.closeSelect()
        }
      })
    },

    addArrowKeyListeners () {
      this.$el.querySelector('#' + this.searchId).addEventListener('keydown', e => {
        switch (e.keyCode) {
        case KEYCODES.down:
          this.incremementKeyboardFocus()
          break
        case KEYCODES.up:
          this.decrementKeyboardFocus()
          break
        case KEYCODES.enter:
          if(this.filteredOptions.length && this.hasKeyboardFocus) {
            this.selectOption(this.filteredOptions[this.highlightedOptionIndex])
          }
          break
        case KEYCODES.esc:
          document.activeElement.blur()
          break
        }
      })
    },

    incremementKeyboardFocus () {
      if (this.highlightedOptionIndex === this.filteredOptions.length - 1) {
        this.highlightedOptionIndex = 0
      } else {
        this.highlightedOptionIndex++
      }
    },

    decrementKeyboardFocus () {
      if (this.highlightedOptionIndex === 0) {
        this.highlightedOptionIndex = this.filteredOptions.length - 1
      } else if (this.hasKeyboardFocus) {
        this.highlightedOptionIndex--
      }
    }
  },
}
