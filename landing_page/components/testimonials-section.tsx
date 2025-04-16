"use client"

import { useRef } from "react"
import Image from "next/image"
import { motion, useInView } from "framer-motion"
import { Star } from "lucide-react"

const testimonials = [
  {
    quote:
      "Intervene has completely transformed how I manage my daily tasks. I'm saving at least 2 hours every day on repetitive work.",
    author: "Alex Johnson",
    role: "Product Manager at Acme Inc.",
    avatar: "/placeholder.svg?height=100&width=100",
  },
  {
    quote:
      "The ability to automate file renaming and organization based on spreadsheet data has been a game-changer for our team.",
    author: "Sarah Chen",
    role: "Operations Director at TechFlow",
    avatar: "/placeholder.svg?height=100&width=100",
  },
  {
    quote:
      "I was skeptical about AI desktop automation, but Intervene's manual takeover feature makes it feel safe and controllable.",
    author: "Michael Rodriguez",
    role: "Senior Developer at BuildCorp",
    avatar: "/placeholder.svg?height=100&width=100",
  },
  {
    quote: "Our team's productivity has increased by 30% since implementing Intervene across our design department.",
    author: "Emma Wilson",
    role: "Creative Director at DesignHub",
    avatar: "/placeholder.svg?height=100&width=100",
  },
]

export default function TestimonialsSection() {
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
    <section id="testimonials" className="relative py-20 md:py-32">
      <div className="absolute inset-0 bg-gradient-to-b from-black via-purple-950/10 to-black" />

      <div className="container relative px-4 md:px-6">
        <div className="mx-auto max-w-3xl text-center">
          <h2 className="text-3xl font-bold tracking-tight sm:text-4xl md:text-5xl">
            Loved by{" "}
            <span className="bg-gradient-to-r from-purple-400 to-violet-400 bg-clip-text text-transparent">
              productive teams
            </span>
          </h2>
          <p className="mt-4 text-lg text-white/70">
            See what our users are saying about how Intervene has transformed their workflow
          </p>
        </div>

        <div ref={ref} className="mt-16">
          <motion.div
            variants={containerVariants}
            initial="hidden"
            animate={isInView ? "visible" : "hidden"}
            className="grid gap-8 md:grid-cols-2 lg:grid-cols-4"
          >
            {testimonials.map((testimonial, index) => (
              <motion.div
                key={index}
                variants={itemVariants}
                className="group relative overflow-hidden rounded-xl border border-white/10 bg-white/5 p-6 backdrop-blur-sm transition-all hover:bg-white/10 hover:shadow-lg hover:shadow-purple-500/5"
              >
                <div className="mb-4 flex">
                  {[...Array(5)].map((_, i) => (
                    <Star key={i} className="h-4 w-4 fill-purple-500 text-purple-500" />
                  ))}
                </div>
                <p className="mb-4 text-white/90">"{testimonial.quote}"</p>
                <div className="flex items-center gap-3">
                  <Image
                    src={testimonial.avatar || "/placeholder.svg"}
                    alt={testimonial.author}
                    width={40}
                    height={40}
                    className="rounded-full"
                  />
                  <div>
                    <h4 className="font-medium">{testimonial.author}</h4>
                    <p className="text-sm text-white/70">{testimonial.role}</p>
                  </div>
                </div>
                <div className="absolute bottom-0 left-0 h-1 w-0 bg-gradient-to-r from-purple-500 to-violet-500 transition-all duration-300 group-hover:w-full"></div>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </div>
    </section>
  )
}
