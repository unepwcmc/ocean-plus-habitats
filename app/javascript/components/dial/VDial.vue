<template>
  <div class="v-dial">
    <svg 
      :class="['v-dial__meter', svgClass]"
      :viewBox="`0 0 ${width} ${width}`"
    >
      <circle
        class="v-dial__circle--background"
        :r="radius"
        cx="50%"
        cy="50%"
        :style="{ strokeDasharray: circumference }"
      />

      <circle
        class="v-dial__circle--colour"
        :r="radius"
        cx="50%"
        cy="50%"
        :style="{ strokeDasharray: circumference, strokeDashoffset: strokeOffset }"
      />

      <circle 
        class="v-dial__marker"         
        :r="markerRadius"
        :cx="markerPoints.x"
        :cy="markerPoints.y"
      />
    </svg>

    <div 
      v-if="this.$slots.default"
      class="v-dial__center"
    >
      <slot />
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

    percentage: {
      type: Number,
      default: null
    }
  },

  data () {
    return {
      inversePercentage: 100 - this.percentage,
      svgClass: `v-dial__meter--${this.id}`,
      markerRadius: 13, // Also defined in dial.scss
      strokeWidth: 8, // Also defined in dial.scss
      markerId: `circle-${this._uid}`,
      width: 196
    }
  },

  computed: {
    radius() {
      return this.width / 2 - this.markerRadius
    },

    circumference() {
      return 2 * this.radius * Math.PI
    },

    strokeOffset() {
      return (this.inversePercentage / 100) * this.circumference
    },

    markerPoints() {
      const
        xFromCenter = this.getCoordFromPercentage(this.percentage, 'x'),
        yFromCenter = this.getCoordFromPercentage(this.percentage, 'y')

      return {
        x: xFromCenter + this.width / 2,
        y: yFromCenter + this.width / 2
      }
    }
  },

  methods: {
    getCoordFromPercentage (percentage, coord) {
      const trig = coord === 'x' ? 'cos' : 'sin'
      const radiansToCoord =  (percentage / 100) * 2 * Math.PI

      return this.radius * Math[trig](radiansToCoord)
    }
  }
}
</script>
