'use client';

import { useRef } from 'react';
import { motion, useInView } from 'framer-motion';
import {
  MousePointer2,
  Cpu,
  KeyRound,
  Calendar,
  ShieldCheck,
  BarChart3,
} from 'lucide-react';

const features = [
  {
    title: 'Autonomous Mode',
    description:
      'Run scripted or inferred actions like renaming files from spreadsheets or extracting info from PDFs to fill a CRM.',
    icon: MousePointer2,
    color: 'from-purple-500/20 to-violet-500/20',
    textColor: 'text-purple-400',
  },
  {
    title: 'Context-Aware Triggers',
    description:
      'Automatically triggers based on context like open tabs, folders, and file names.',
    icon: Cpu,
    color: 'from-blue-500/20 to-indigo-500/20',
    textColor: 'text-blue-400',
  },
  {
    title: 'Manual Takeover',
    description:
      'Just move the mouse or press any key — agent halts instantly. Switch back via hotkey or voice.',
    icon: KeyRound,
    color: 'from-green-500/20 to-emerald-500/20',
    textColor: 'text-green-400',
  },
  {
    title: 'Memory & Context',
    description:
      'Remembers past workflows: e.g. "every Monday, generate status report from these folders."',
    icon: Calendar,
    color: 'from-amber-500/20 to-yellow-500/20',
    textColor: 'text-amber-400',
  },
  {
    title: 'Safety & Guardrails',
    description:
      'Llama Safety API ensures no files/emails/data are sent or altered without local confirmation.',
    icon: ShieldCheck,
    color: 'from-red-500/20 to-rose-500/20',
    textColor: 'text-red-400',
  },
  {
    title: 'Efficiency Reporting',
    description:
      '"This week Copilot Mode saved you 3.2 hours on repetitive tasks."',
    icon: BarChart3,
    color: 'from-indigo-500/20 to-blue-500/20',
    textColor: 'text-indigo-400',
  },
];

export default function FeaturesGrid() {
  const ref = useRef<HTMLDivElement>(null);
  const isInView = useInView(ref, { once: true, amount: 0.2 });

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1,
      },
    },
  };

  const itemVariants = {
    hidden: { opacity: 0, y: 20 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        duration: 0.5,
      },
    },
  };

  return (
    <section id="features" className="relative py-20 md:py-32">
      <div className="absolute inset-0 bg-gradient-to-b from-black via-purple-950/10 to-black" />
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
            Autopilot for your{' '}
            <span className="bg-gradient-to-r from-purple-400 to-violet-400 bg-clip-text text-transparent">
              desktop workflows
            </span>
          </h2>
          <p className="mt-4 text-lg text-white/70">
            Built entirely on-device using Meta&apos;s Llama Stack for fast,
            private, agentic task execution.
          </p>
        </div>

        <div ref={ref} className="mt-20">
          <motion.div
            variants={containerVariants}
            initial="hidden"
            animate={isInView ? 'visible' : 'hidden'}
            className="grid gap-8 md:grid-cols-2 lg:grid-cols-3"
          >
            {features.map((feature, index) => (
              <motion.div
                key={index}
                variants={itemVariants}
                className="group relative overflow-hidden rounded-xl border border-white/10 bg-black/40 p-6 backdrop-blur-sm transition-all hover:bg-white/5 hover:shadow-lg hover:shadow-purple-500/5"
              >
                <div
                  className={`absolute inset-0 bg-gradient-to-br ${feature.color} opacity-10 group-hover:opacity-20`}
                />

                <div
                  className={`relative mb-4 inline-flex h-12 w-12 items-center justify-center rounded-lg bg-gradient-to-br ${feature.color} backdrop-blur-md`}
                >
                  <feature.icon className={`h-6 w-6 ${feature.textColor}`} />
                </div>

                <h3
                  className={`relative mb-2 text-xl font-bold ${feature.textColor}`}
                >
                  {feature.title}
                </h3>
                <p className="relative text-white/70">{feature.description}</p>
                <div className="absolute bottom-0 left-0 h-1 w-0 bg-gradient-to-r from-purple-500 to-violet-500 transition-all duration-300 group-hover:w-full"></div>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </div>
    </section>
  );
}