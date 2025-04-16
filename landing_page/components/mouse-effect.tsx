"use client"

import { useEffect, useState } from "react"
import { motion, useSpring, useMotionValue } from "framer-motion"

export default function MouseEffect() {
  // Create motion values at the top level of the component
  const cursorX = useMotionValue(0)
  const cursorY = useMotionValue(0)
  
  // Create spring configs
  const springConfig = { damping: 25, stiffness: 300 }
  
  // Create springs at the top level
  const cursorXSpring = useSpring(cursorX, springConfig)
  const cursorYSpring = useSpring(cursorY, springConfig)
  
  // For the larger glow effect
  const glowX = useSpring(cursorX, { ...springConfig, damping: 40, stiffness: 100 })
  const glowY = useSpring(cursorY, { ...springConfig, damping: 40, stiffness: 100 })
  
  const [cursorVariant, setCursorVariant] = useState("default")
  const [isHovering, setIsHovering] = useState(false)
  
  // For the trail effect
  const trailElements = 5
  
  // Pre-create all motion values at component top level
  const trailMotionX = [
    useMotionValue(0),
    useMotionValue(0),
    useMotionValue(0),
    useMotionValue(0),
    useMotionValue(0)
  ]
  
  const trailMotionY = [
    useMotionValue(0),
    useMotionValue(0),
    useMotionValue(0),
    useMotionValue(0),
    useMotionValue(0)
  ]
  
  // Pre-create all springs at component top level
  const trailSpringsX = [
    useSpring(trailMotionX[0], { ...springConfig, stiffness: 300 - 0 * 40, damping: 20 + 0 * 5 }),
    useSpring(trailMotionX[1], { ...springConfig, stiffness: 300 - 1 * 40, damping: 20 + 1 * 5 }),
    useSpring(trailMotionX[2], { ...springConfig, stiffness: 300 - 2 * 40, damping: 20 + 2 * 5 }),
    useSpring(trailMotionX[3], { ...springConfig, stiffness: 300 - 3 * 40, damping: 20 + 3 * 5 }),
    useSpring(trailMotionX[4], { ...springConfig, stiffness: 300 - 4 * 40, damping: 20 + 4 * 5 })
  ]
  
  const trailSpringsY = [
    useSpring(trailMotionY[0], { ...springConfig, stiffness: 300 - 0 * 40, damping: 20 + 0 * 5 }),
    useSpring(trailMotionY[1], { ...springConfig, stiffness: 300 - 1 * 40, damping: 20 + 1 * 5 }),
    useSpring(trailMotionY[2], { ...springConfig, stiffness: 300 - 2 * 40, damping: 20 + 2 * 5 }),
    useSpring(trailMotionY[3], { ...springConfig, stiffness: 300 - 3 * 40, damping: 20 + 3 * 5 }),
    useSpring(trailMotionY[4], { ...springConfig, stiffness: 300 - 4 * 40, damping: 20 + 4 * 5 })
  ]
  
  useEffect(() => {
    const mouseMove = (e: MouseEvent) => {
      cursorX.set(e.clientX)
      cursorY.set(e.clientY)
      
      // Update trail positions with delay
      setTimeout(() => {
        for (let i = 0; i < trailElements; i++) {
          trailMotionX[i].set(e.clientX)
          trailMotionY[i].set(e.clientY)
        }
      }, 100) // Slight delay for trail effect
    }
    
    window.addEventListener("mousemove", mouseMove)
    
    return () => {
      window.removeEventListener("mousemove", mouseMove)
    }
  }, [cursorX, cursorY, trailMotionX, trailMotionY]) // Added missing dependencies
  
  useEffect(() => {
    const interactiveElements = document.querySelectorAll(
      "a, button, h1, h2, h3, h4, h5, h6, input, [role='button'], .interactive"
    )
    
    const mouseEnter = () => {
      setCursorVariant("hover")
      setIsHovering(true)
    }
    
    const mouseLeave = () => {
      setCursorVariant("default")
      setIsHovering(false)
    }
    
    interactiveElements.forEach((element) => {
      element.addEventListener("mouseenter", mouseEnter)
      element.addEventListener("mouseleave", mouseLeave)
    })
    
    return () => {
      interactiveElements.forEach((element) => {
        element.removeEventListener("mouseenter", mouseEnter)
        element.removeEventListener("mouseleave", mouseLeave)
      })
    }
  }, [])
  
  const variants = {
    default: {
      height: 32,
      width: 32,
      opacity: 0.5,
      mixBlendMode: "difference" as const,
    },
    hover: {
      height: 64,
      width: 64,
      opacity: 0.8,
      backgroundColor: "rgba(139, 92, 246, 0.3)",
      mixBlendMode: "screen" as const,
    },
  }
  
  return (
    <>
      {/* Main cursor */}
      <motion.div
        className="pointer-events-none fixed left-0 top-0 z-50 rounded-full bg-purple-500"
        style={{
          x: cursorXSpring,
          y: cursorYSpring,
          translateX: "-50%",
          translateY: "-50%",
        }}
        variants={variants}
        animate={cursorVariant}
        transition={{
          type: "spring",
          stiffness: 500,
          damping: 28,
          mass: 0.5,
        }}
      />
      
      {/* Cursor glow effect */}
      <motion.div
        className="pointer-events-none fixed left-0 top-0 z-40 h-40 w-40 rounded-full bg-gradient-radial from-purple-500/20 via-violet-500/10 to-transparent blur-xl"
        style={{
          x: glowX,
          y: glowY,
          translateX: "-50%",
          translateY: "-50%",
          opacity: isHovering ? 0.8 : 0.4,
          scale: isHovering ? 1.5 : 1,
        }}
        transition={{
          opacity: { duration: 0.2 },
          scale: { duration: 0.4 },
        }}
      />
      
      {/* Cursor trails */}
      {Array.from({ length: trailElements }).map((_, i) => (
        <motion.div
          key={i}
          className="pointer-events-none fixed left-0 top-0 z-30 h-2 w-2 rounded-full bg-purple-400"
          style={{
            x: trailSpringsX[i],
            y: trailSpringsY[i],
            translateX: "-50%",
            translateY: "-50%",
            opacity: 0.3 - i * 0.05,
            scale: 1 - i * 0.15,
          }}
          transition={{
            type: "spring",
            stiffness: 300 - i * 40,
            damping: 20 + i * 5,
            mass: 0.5 + i * 0.1,
            delay: i * 0.02,
          }}
        />
      ))}
      
      {/* Magnetic effect for buttons - applied via CSS */}
      <style jsx global>{`
        a, button, .magnetic {
          transition: transform 0.2s cubic-bezier(0.23, 1, 0.32, 1);
        }
        
        a:hover, button:hover, .magnetic:hover {
          transform: translateY(-2px);
        }
      `}</style>
    </>
  )
}