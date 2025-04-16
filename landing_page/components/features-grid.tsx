"use client"

import { useRef } from "react"
import { motion, useInView } from "framer-motion"
import {
  MousePointer2,
  Cpu,
  KeyRound,
  Calendar,
  ShieldCheck,
  BarChart3,
  Search,
  Lightbulb,
  Zap,
  Shield,
  Clock,
  Sparkles,
} from "lucide-react"

const features = [
  {
    title: "Autonomous Mode",
    description:
      "Run scripted or inferred actions like renaming files from spreadsheets or extracting info from PDFs to fill a CRM.",
    icon: MousePointer2,
    color: "from-purple-500/20 to-violet-500/20",
    textColor: "text-purple-400",
  },
  {
    title: "Context-Aware Triggers",
    description: "Automatically triggers based on context like open tabs, folders, and file names.",
    icon: Cpu,
    color: "from-blue-500/20 to-indigo-500/20",
    textColor: "text-blue-400",
  },
  {
    title: "Manual Takeover",
    description: "Just move the mouse or press any key — agent halts instantly. Switch back via hotkey or voice.",
    icon: KeyRound,
    color: "from-green-500/20 to-emerald-500/20",
    textColor: "text-green-400",
  },
  {
    title: "Memory & Context",
    description: 'Remembers past workflows: e.g. "every Monday, generate status report from these folders."',
    icon: Calendar,
    color: "from-amber-500/20 to-yellow-500/20",
    textColor: "text-amber-400",
  },
  {
    title: "Safety & Guardrails",
    description: "Llama Safety API ensures no files/emails/data are sent or altered without local confirmation.",
    icon: ShieldCheck,
    color: "from-red-500/20 to-rose-500/20",
    textColor: "text-red-400",
  },
  {
    title: "Efficiency Reporting",
    description: '"This week Copilot Mode saved you 3.2 hours on repetitive tasks."',
    icon: BarChart3,
    color: "from-indigo-500/20 to-blue-500/20",
    textColor: "text-indigo-400",
  },
]

// Categories like in the screenshots
const categories = [
  { name: "Security", icon: Shield, color: "bg-blue-900/30" },
  { name: "Strategy", icon: Lightbulb, color: "bg-purple-900/30" },
  { name: "Product", icon: Zap, color: "bg-violet-900/30" },
  { name: "People", icon: Search, color: "bg-teal-900/30" },
  { name: "Design", icon: Sparkles, color: "bg-pink-900/30" },
  { name: "Sales", icon: Clock, color: "bg-indigo-900/30" },
]

export default function FeaturesGrid() {
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
    <section id="features" className="relative py-20 md:py-32">
      <div className="absolute inset-0 bg-gradient-to-b from-black via-purple-950/10 to-black" />

      {/* Floating elements like in the screenshots */}
      <motion.div
        className="absolute top-1/4 left-1/4 h-40 w-40 rounded-full bg-gradient-to-r from-purple-600/20 to-violet-600/20 blur-3xl"
        animate={{
          x: [0, 30, 0],
          y: [0, -30, 0],
        }}
        transition={{
          duration: 8,
          repeat: Number.POSITIVE_INFINITY,
          repeatType: "reverse",
        }}
      />

      <motion.div
        className="absolute bottom-1/3 right-1/3 h-60 w-60 rounded-full bg-gradient-to-r from-blue-600/20 to-cyan-600/20 blur-3xl"
        animate={{
          x: [0, -40, 0],
          y: [0, 40, 0],
        }}
        transition={{
          duration: 10,
          repeat: Number.POSITIVE_INFINITY,
          repeatType: "reverse",
        }}
      />

      <div className="container relative px-4 md:px-6">
        <div className="mx-auto max-w-3xl text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="inline-block rounded-full bg-gradient-to-r from-purple-600/10 to-violet-600/10 px-4 py-1.5 text-sm font-medium text-purple-300 backdrop-blur"
          >
            <span className="mr-2 inline-block h-2 w-2 animate-pulse rounded-full bg-purple-500"></span>
            OS-Level Automation
          </motion.div>

          <h2 className="mt-6 text-3xl font-bold tracking-tight sm:text-4xl md:text-5xl">
            Tesla Autopilot for your{" "}
            <span className="bg-gradient-to-r from-purple-400 to-violet-400 bg-clip-text text-transparent">
              desktop workflows
            </span>
          </h2>
          <p className="mt-4 text-lg text-white/70">
            Built entirely on-device using Meta&apos;s Llama Stack for fast, private, agentic task execution.
          </p>
        </div>

        {/* Categories section like in the screenshots */}
        <div className="mt-16 overflow-hidden">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 1 }}
            className="flex flex-wrap justify-center gap-4"
          >
            {categories.map((category, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
                className={`relative flex items-center justify-center rounded-lg ${category.color} px-6 py-3 text-lg font-medium backdrop-blur-sm transition-all hover:scale-105`}
              >
                <category.icon className="mr-2 h-5 w-5" />
                {category.name}
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Main features section */}
        <div ref={ref} className="mt-20">
          <motion.div
            variants={containerVariants}
            initial="hidden"
            animate={isInView ? "visible" : "hidden"}
            className="grid gap-8 md:grid-cols-2 lg:grid-cols-3"
          >
            {features.map((feature, index) => (
              <motion.div
                key={index}
                variants={itemVariants}
                className="group relative overflow-hidden rounded-xl border border-white/10 bg-black/40 p-6 backdrop-blur-sm transition-all hover:bg-white/5 hover:shadow-lg hover:shadow-purple-500/5"
              >
                {/* Gradient background */}
                <div
                  className={`absolute inset-0 bg-gradient-to-br ${feature.color} opacity-10 transition-opacity group-hover:opacity-20`}
                />

                {/* Icon with gradient background */}
                <div
                  className={`relative mb-4 inline-flex h-12 w-12 items-center justify-center rounded-lg bg-gradient-to-br ${feature.color} backdrop-blur-md`}
                >
                  <feature.icon className={`h-6 w-6 ${feature.textColor}`} />
                </div>

                <h3 className={`relative mb-2 text-xl font-bold ${feature.textColor}`}>{feature.title}</h3>
                <p className="relative text-white/70">{feature.description}</p>

                {/* Animated border on hover */}
                <div className="absolute bottom-0 left-0 h-1 w-0 bg-gradient-to-r from-purple-500 to-violet-500 transition-all duration-300 group-hover:w-full"></div>
              </motion.div>
            ))}
          </motion.div>
        </div>

        {/* Email problem section like in the screenshots */}
        <div className="mt-32">
          <div className="mx-auto max-w-4xl">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7 }}
              viewport={{ once: true }}
              className="text-center"
            >
              <h2 className="text-4xl font-bold tracking-tight md:text-5xl">
                Desktop tasks are the{" "}
                <span className="bg-gradient-to-r from-orange-400 to-pink-400 bg-clip-text text-transparent">
                  biggest problem
                </span>
                <br />
                <span className="bg-gradient-to-r from-purple-400 to-violet-400 bg-clip-text text-transparent">
                  hiding in plain sight
                </span>
              </h2>

              <p className="mt-8 text-xl text-white/80">
                We all spend hours on repetitive tasks. But we often get distracted, make mistakes, and waste time.
              </p>
              <p className="mt-4 text-xl text-white/80">
                We then end up losing focus, blocking our productivity, and missing our goals.
              </p>

              <div className="mt-12">
                <p className="text-xl text-white/80">
                  It&apos;s not anybody&apos;s fault. Desktop workflows haven&apos;t changed in decades.
                </p>
                <p className="mt-2 text-xl text-white/80">With Intervene, this all changes.</p>
              </div>
            </motion.div>
          </div>
        </div>
      </div>
    </section>
  )
}
