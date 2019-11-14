<template>
  <div
    class="v-select relative"
    :class="{'v-select--disabled': isDisabled}"
  >
    <button
      :id="toggleId"
      type="button"
      class="v-select__toggle"
      :class="{'active': isActive}"
      aria-haspopup="true"
      :aria-controls="mixinModalId"
      :disabled="isDisabled"
      @click="toggleSelect"
    >
      <span class="v-select__dropdown-text">{{ selectionMessage }}</span>
      <i class="drop-arrow arrow-svg" />
    </button>

    <ul 
      v-show="isActive"
      :id="mixinModalId" 
      role="radiogroup" 
      class="v-select__dropdown"
    >
      <li
        v-for="option in options"
        :key="option.id"
        class="v-select__option"
      >
        <label
          class="v-select__option-label"
          :for="getOptionInputId(option)"
          @mouseup="closeSelect"
        >
          <input
            :id="getOptionInputId(option)"
            v-model="selectedInternal"
            class="v-select__default-radio"
            type="radio"
            :name="dropdownOptionsName"
            :value="option"
          >
          <span class="v-select__radio" />
          <span>{{ option.name }}</span>
        </label>
      </li>
    </ul>
  </div>
</template>

<script>
import mixinPopupCloseListeners from '../../mixins/mixin-popup-close-listeners'
import mixinFocusCapture from '../../mixins/mixin-focus-capture'

const UNDEFINED_ID = '__UNDEFINED__'
const UNDEFINED_OBJECT = { id: UNDEFINED_ID, name: 'None' }
const DEFAULT_SELECT_MESSAGE = 'Select option'

export default {
  name: 'VSelect',

  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeSelect'}),
    mixinFocusCapture({toggleVariable: 'isActive', closeCallback: 'closeSelect', openCallback: 'openSelect'})
  ],

  props: {
    id: {
      type: String,
      required: true
    },
    options: {
      default: () => [],
      type: Array
    },
    selected: {
      type: Object,
      default: () => UNDEFINED_OBJECT
    },
    event: {
      type: String,
    }
  },

  data () {
    return {
      isActive: false,
      selectedInternal: null,
      dropdownOptionsName: 'v-select-dropdown-input' + this.id,
      toggleId: 'v-select-toggle-' + this.id,
      mixinTriggerId: 'v-select-toggle-' + this.id,
      mixinIsRadioGroup: true,
      mixinModalId: 'v-select-dropdown-' + this.id
    }
  },

  computed: {
    isDisabled () {
      return !this.options.length
    },

    selectionMessage () {
      return this.selectedInternal.id === UNDEFINED_ID ? DEFAULT_SELECT_MESSAGE : this.selectedInternal.name
    }
  },

  watch: {
    selected (newSelectedOption) {
      this.selectedInternal = newSelectedOption === null ?
        UNDEFINED_OBJECT :
        newSelectedOption
    },

    selectedInternal (newSelectedInternal) {
      this.$emit('update:selected-option', newSelectedInternal)
      this.$eventHub.$emit(this.event, newSelectedInternal)
    }
  },

  created () {
    this.initializeSelectedInternal()
  },

  methods: {
    closeSelect () {
      this.isActive = false
    },

    openSelect () {
      this.isActive = true
    },

    toggleSelect (e) {
      if (this.options.length && !this.isActive) {
        this.openSelect(e)
      } else {
        this.closeSelect(e)
      }
    },

    initializeSelectedInternal () {
      if (this.selected === null) {
        this.selectedInternal = UNDEFINED_OBJECT
      } else {
        this.selectedInternal = this.selected
      }

      this.closeSelect()
    },

    isSelected (option) {
      return option.id === this.selectedInternal.id
    },

    getOptionInputId (option) {
      return `option-${this.id}-${option.id}`
    }
  }
}
</script>