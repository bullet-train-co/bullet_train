// MIT License
//
// Copyright (c) 2021 Dom Christie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

class Turn {
  constructor (action) {
    this.action = action
    this.beforeExitClasses = new Set()
    this.exitClasses = new Set()
    this.enterClasses = new Set()
  }

  exit () {
    this.animateOut = animationsEnd('[data-turn-exit]')
    this.addClasses('before-exit')
    requestAnimationFrame(() => {
      this.addClasses('exit')
      this.removeClasses('before-exit')
    })
  }

  async beforeEnter (event) {
    if (this.action === 'restore') return

    event.preventDefault()

    if (this.isPreview) {
      this.hasPreview = true
      await this.animateOut
    } else {
      await this.animateOut
      if (this.animateIn) await this.animateIn
    }

    event.detail.resume()
  }

  async enter () {
    this.removeClasses('exit')

    if (this.shouldAnimateEnter) {
      this.animateIn = animationsEnd('[data-turn-enter]')
      this.addClasses('enter')
    }
  }

  async complete () {
    await this.animateIn
    this.removeClasses('enter')
  }

  abort () {
    this.removeClasses('before-exit')
    this.removeClasses('exit')
    this.removeClasses('enter')
  }

  get shouldAnimateEnter () {
    if (this.action === 'restore') return false
    if (this.isPreview) return true
    if (this.hasPreview) return false
    return true
  }

  get isPreview () {
    return document.documentElement.hasAttribute('data-turbo-preview')
  }

  addClasses (type) {
    document.documentElement.classList.add(`turn-${type}`)

    Array.from(document.querySelectorAll(`[data-turn-${type}]`)).forEach((element) => {
      element.dataset[`turn${pascalCase(type)}`].split(/\s+/).forEach((klass) => {
        if (klass) {
          element.classList.add(klass)
          this[`${camelCase(type)}Classes`].add(klass)
        }
      })
    })
  }

  removeClasses (type) {
    document.documentElement.classList.remove(`turn-${type}`)

    Array.from(document.querySelectorAll(`[data-turn-${type}]`)).forEach((element) => {
      this[`${camelCase(type)}Classes`].forEach((klass) => element.classList.remove(klass))
    })
  }
}

Turn.start = function () {
  if (motionSafe()) {
    for (var event in this.eventListeners) {
      addEventListener(event, this.eventListeners[event])
    }
  }
}

Turn.stop = function () {
  for (var event in this.eventListeners) {
    removeEventListener(event, this.eventListeners[event])
  }
  delete this.currentTurn
}

Turn.eventListeners = {
  'turbo:visit': function (event) {
    if (this.currentTurn) this.currentTurn.abort()
    this.currentTurn = new this(event.detail.action)
    this.currentTurn.exit()
  }.bind(Turn),
  'turbo:before-render': function (event) {
    this.currentTurn.beforeEnter(event)
  }.bind(Turn),
  'turbo:render': function () {
    this.currentTurn.enter()
  }.bind(Turn),
  'turbo:load': function () {
    if (this.currentTurn) this.currentTurn.complete()
  }.bind(Turn),
  'popstate': function () {
    if (this.currentTurn && this.currentTurn.action !== 'restore') {
      this.currentTurn.abort()
    }
  }.bind(Turn)
}

function prefersReducedMotion () {
  const mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)')
  return !mediaQuery || mediaQuery.matches
}

function motionSafe () {
  return !prefersReducedMotion()
}

function animationsEnd (selector) {
  const elements = [...document.querySelectorAll(selector)]

  return Promise.all(elements.map((element) => {
    return new Promise((resolve) => {
      function listener () {
        element.removeEventListener('animationend', listener)
        resolve()
      }
      element.addEventListener('animationend', listener)
    })
  }))
}

function pascalCase (string) {
  return string.split(/[^\w]/).map(capitalize).join('')
}

function camelCase (string) {
  return string.split(/[^\w]/).map(
    (w, i) => i === 0 ? w.toLowerCase() : capitalize(w)
  ).join('')
}

function capitalize (string) {
  return string.replace(/^\w/, (c) => c.toUpperCase())
}

Turn.start()
