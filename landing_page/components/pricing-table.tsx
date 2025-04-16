"use client"

import { useRef } from "react"
import Link from "next/link"
import { motion, useInView } from "framer-motion"
import { Check } from "lucide-react"

const plans = [
  {
    name: "Personal",
    price: "$9",
    description: "Perfect for individual users",
    features: [
      "Autonomous desktop workflows",
      "Manual takeover system",
      "Basic efficiency reporting",
      "Single device license",
      "Community support",
    ],
    cta: "Get Started",
    popular: false,
  },
  {
    name: "Pro",
    price: "$19",
    description: "For power users and freelancers",
    features: [
      "Everything in Personal",
      "Advanced workflow creation",
      "Custom triggers and actions",
      "Up to 3 device licenses",
      "Priority support",
      "Workflow templates library",
    ],
    cta: "Get Started",
    popular: true,
  },
  {
    name: "Team",
    price: "$49",
    description: "For small teams and businesses",
    features: [
      "Everything in Pro",
      "Team workflow sharing",
      "Admin dashboard",
      "Team efficiency analytics",
      "Up to 10 device licenses",
      "Dedicated support",
      "Custom integration options",
    ],
    cta: "Contact Sales",
    popular: false,
  },
]

export default function PricingTable() {
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
    <section id="pricing" className="relative py-20 md:py-32">
      <div className="absolute inset-0 bg-gradient-to-b from-black via-purple-950/10 to-black" />

      <div className="container relative px-4 md:px-6">
        <div className="mx-auto max-w-3xl text-center">
          <h2 className="text-3xl font-bold tracking-tight sm:text-4xl md:text-5xl">
            Simple, transparent{" "}
            <span className="bg-gradient-to-r from-purple-400 to-violet-400 bg-clip-text text-transparent">
              pricing
            </span>
          </h2>
          <p className="mt-4 text-lg text-white/70">Choose the plan that&apos;s right for you or your team</p>
        </div>

        <div ref={ref} className="mt-16">
          <motion.div
            variants={containerVariants}
            initial="hidden"
            animate={isInView ? "visible" : "hidden"}
            className="grid gap-8 md:grid-cols-3"
          >
            {plans.map((plan, index) => (
              <motion.div
                key={index}
                variants={itemVariants}
                className={`relative overflow-hidden rounded-xl border ${
                  plan.popular
                    ? "border-purple-500 bg-gradient-to-b from-purple-900/20 to-black"
                    : "border-white/10 bg-white/5"
                } p-8 backdrop-blur-sm transition-all hover:shadow-lg hover:shadow-purple-500/5`}
              >
                {plan.popular && (
                  <div className="absolute right-0 top-0 rounded-bl-lg bg-gradient-to-r from-purple-600 to-violet-600 px-4 py-1 text-xs font-medium">
                    Most Popular
                  </div>
                )}
                <h3 className="text-xl font-bold">{plan.name}</h3>
                <div className="mt-4 flex items-baseline">
                  <span className="text-4xl font-bold">{plan.price}</span>
                  <span className="ml-1 text-white/70">/month</span>
                </div>
                <p className="mt-2 text-sm text-white/70">{plan.description}</p>

                <ul className="mt-6 space-y-3">
                  {plan.features.map((feature, i) => (
                    <li key={i} className="flex items-center gap-2">
                      <Check className="h-4 w-4 text-purple-500" />
                      <span className="text-sm">{feature}</span>
                    </li>
                  ))}
                </ul>

                <div className="mt-8">
                  <Link
                    href="#download"
                    className={`inline-flex h-10 w-full items-center justify-center rounded-md ${
                      plan.popular
                        ? "bg-gradient-to-r from-purple-600 to-violet-600 text-white"
                        : "border border-white/10 bg-white/5 text-white hover:bg-white/10"
                    } px-4 text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-purple-500`}
                  >
                    {plan.cta}
                  </Link>
                </div>
              </motion.div>
            ))}
          </motion.div>

          <div className="mt-12 text-center">
            <p className="text-white/70">All plans include a 14-day free trial. No credit card required.</p>
          </div>
        </div>
      </div>
    </section>
  )
}
