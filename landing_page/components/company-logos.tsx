"use client"

import { useRef } from "react"
import Image from "next/image"
import { motion, useInView } from "framer-motion"

export default function CompanyLogos() {
  const ref = useRef<HTMLDivElement>(null)
  const isInView = useInView(ref, { once: true, amount: 0.2 })

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1,
      },
    },
  }

  const itemVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        duration: 0.5,
      },
    },
  }

  return (
    <section className="relative py-12 md:py-16">
      <div className="container px-4 md:px-6">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-sm font-medium text-white/50 uppercase tracking-wider">Trusted by innovative teams at</p>
        </div>

        <div ref={ref} className="mt-8">
          <motion.div
            variants={containerVariants}
            initial="hidden"
            animate={isInView ? "visible" : "hidden"}
            className="flex flex-wrap items-center justify-center gap-8 md:gap-12 opacity-70"
          >
            {[...Array(6)].map((_, index) => (
              <motion.div key={index} variants={itemVariants} className="flex items-center justify-center">
                <Image
                  src="/placeholder-logo.svg"
                  alt={`Company logo ${index + 1}`}
                  width={120}
                  height={40}
                  className="h-8 w-auto object-contain grayscale transition-all hover:grayscale-0"
                />
              </motion.div>
            ))}
          </motion.div>
        </div>
      </div>
    </section>
  )
}
