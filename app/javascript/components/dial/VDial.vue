<template>
  <div class="v-dial">
    <div
      class="v-dial__wrapper"
      :style="{ width: width + 'px', height: width + 'px' }"
    >
      <i
        :class="['v-dial__icon', iconClass]"
        :alt="iconAlt"
      />
      <svg :class="['v-dial__meter', svgClass]">
        <!-- Outline Curves -->
        <circle
          class="v-dial__circle--outline-curves"
          :r="radius"
          cx="50%"
          cy="50%"
        />
        <!-- Background -->
        <circle
          class="v-dial__circle--background"
          :r="radius"
          cx="50%"
          cy="50%"
          :style="{ strokeDasharray: circumference }"
        />
        <!-- Colour -->
        <circle
          class="v-dial__circle--colour"
          :r="radius"
          cx="50%"
          cy="50%"
          :style="{ strokeDasharray: circumference, strokeDashoffset: strokeOffset }"
        />
      </svg>
    </div>
  </div>
</template>

<script>

export default {
  name: 'VDial',

  props: {
    id: {
      type: String,
      default: ''
    },
    name: {
      type: String,
      default: ''
    },
    iconClass: {
      type: String,
      default: ''
    },
    percentage: {
      type: Number,
      default: null
    },
    width: {
      type: Number,
      default: null
    }
  },

  data () {
    return {
      iconAlt: this.name + ' icon',
      inversePercentage: 100 - this.percentage,
      radius: (this.width / 2) - 8, // 8 is from the outer stroke of dial
      svgClass: `v-dial__meter--${this.id}`
    }
  },

  computed: {
    circumference() {
      return 2 * this.radius * Math.PI
    },
    strokeOffset() {
      return (this.inversePercentage / 100) * this.circumference
    }
  }
}
</script>
