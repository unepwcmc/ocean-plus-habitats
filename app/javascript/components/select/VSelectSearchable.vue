<template>
  <div
    class="v-select v-select--search relative"
    :class="{'disabled': isDisabled, 'active': isActive}"
  >
    <input
      :id="config.id"
      :value="selectedInternal"
      type="hidden"
      :name="config.id"
    />

    <div
      v-if="config.label"
      class="v-select__label flex flex-v-center hover--pointer"
    >
      <label
        :for="toggleId"
        class="v-select__selection no-margin"
      >{{ config.label }}</label>
      <slot name="label-icon" />
    </div>

    <div class="v-select__click-area">
      <div class="v-select__search relative">
        <input
          :id="searchId"
          v-model="searchTerm"
          class="v-select__search-input"
          type="text"
          role="combobox"
          aria-haspopup="listbox"
          aria-autocomplete="list"
          autocomplete="search-term"
          :aria-expanded="showOptions.toString()"
          :aria-owns="dropdownId"
          :aria-activedescendant="highlightedOptionId"
          :placeholder="getPlaceholderText"
          :disabled="isDisabled"
          @focus="openSelect"
        >

        <span class="v-select__search-icons">
          <span
            v-show="!showResetIcon"
            class="v-select__search-icon"
          />
          <button
            v-show="showResetIcon"
            :id="searchResetId"
            class="v-select__search-icon v-select__search-icon--reset hover--pointer"
            @click="resetSearchTerm"
          />
        </span>
      </div>

      <div
        v-show="showOptions"
        class="v-select__dropdown-wrapper"
      >
        <ul
          :id="dropdownId"
          role="listbox"
          class="v-select__dropdown"
        >
          <li
            v-for="(option, index) in filteredOptions"
            v-show="matchesSearchTerm(option)"
            :id="getOptionInputId(option)"
            :key="option.id"
            :class="['v-select__option flex', conditionalOptionClasses(option, index)]"
            role="option"
            :aria-selected="isHighlighted(index).toString()"
            @click="redirectToCountryPage(option)"
          >
            <span>{{ option.name }}</span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import mixinSelectShared from '../../mixins/mixin-select-shared'
const UNDEFINED_ID = '__UNDEFINED__'

export default {
  mixins: [
    mixinSelectShared
  ],

  props: {
    config: {
      required: true,
      type: Object
    },
    options: {
      default: () => [],
      type: Array
    },
    selected: {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      selectedInternal: null
    }
  },

  computed: {
    filteredOptions () {
      return this.options.filter(option => this.matchesSearchTerm(option))
    }
  },

  watch: {
    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption === null ?
        this.UNDEFINED_ID :
        newSelectedOption
      this.setSearchTermToSelected()
    }
  },

  methods: {
    openSelect () {
      this.searchTerm = ''
      this.isActive = true
    },

    closeSelect () {
      this.setSearchTermToSelected()
      this.resetHighlightedIndex()
      this.isActive = false
    },

    initializeSelectedInternal () {

      if (this.selected === null) {
        this.selectedInternal = UNDEFINED_ID
      } else {
        this.selectedInternal = this.selected
        this.setSearchTermToSelected()
      }
    },

    isSelected (option) {
      return option.id === this.selectedInternal
    },

    selectOption (option) {
      this.selectedInternal = option.id
      this.closeSelect()
      document.activeElement.blur()
    },

    redirectToCountryPage (option) {
      const country = this.options.filter( country => country.id === option.id )[0]

      window.location.href = country.url
    },

    resetSearchTerm () {
      this.$el.querySelector('#' + this.searchId).focus()
      this.searchTerm = ''
    },

    setSearchTermToSelected () {
      if (this.selectedInternal === UNDEFINED_ID) {
        this.searchTerm = ''
      } else {
        const selectedOption = this.getOptionFromId(this.selectedInternal)

        this.searchTerm = selectedOption ? selectedOption.name : ''
      }
    }
  }
}
</script>
