'use client';

import { useRef } from 'react';
import { motion, useInView } from 'framer-motion';
import { FileText, FolderOpen, Mail, LayoutGrid } from 'lucide-react';

const useCases = [
  {
    id: 'form-filling',
    title: 'Form Filling',
    description: 'Automatically fill forms with data from various sources.',
    icon: FileText,
    color: 'from-violet-500/20 to-purple-500/20',
    textColor: 'text-violet-400',
  },
  {
    id: 'file-organization',
    title: 'File Organization',
    description:
      'Rename, sort, and organize files based on content or metadata.',
    icon: FolderOpen,
    color: 'from-pink-500/20 to-rose-500/20',
    textColor: 'text-pink-400',
  },
  {
    id: 'email-management',
    title: 'Email Management',
    description: 'Draft responses, categorize emails, and manage your inbox.',
    icon: Mail,
    color: 'from-cyan-500/20 to-blue-500/20',
    textColor: 'text-cyan-400',
  },
  {
    id: 'tab-organization',
    title: 'Tab Organization',
    description: 'Group and organize browser tabs based on projects or topics.',
    icon: LayoutGrid,
    color: 'from-orange-500/20 to-amber-500/20',
    textColor: 'text-orange-400',
  },
];

export default function UseCasesSection() {
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
      transition: { duration: 0.5 },
    },
  };

  return (
    <section id="use-cases" className="relative py-20 md:py-32">
      <div className="absolute inset-0 bg-gradient-to-b from-black via-purple-950/10 to-black" />

      <div className="container relative px-4 md:px-6">
        <div className="mx-auto max-w-3xl text-center mb-20">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            viewport={{ once: true }}
            className="inline-block rounded-full bg-gradient-to-r from-purple-600/10 to-violet-600/10 px-4 py-1.5 text-sm font-medium text-purple-300 backdrop-blur"
          >
            <span className="mr-2 inline-block h-2 w-2 animate-pulse rounded-full bg-purple-500"></span>
            Powerful Automation
          </motion.div>

          <motion.h2
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.1 }}
            viewport={{ once: true }}
            className="mt-6 text-3xl font-bold tracking-tight sm:text-4xl md:text-5xl"
          >
            Fly through your{' '}
            <span className="bg-gradient-to-r from-purple-400 to-violet-400 bg-clip-text text-transparent">
              workflows
            </span>{' '}
            twice as fast
          </motion.h2>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            viewport={{ once: true }}
            className="mt-4 text-lg text-white/70"
          >
            Be more responsive to what matters most. Collaborate faster than
            ever before.
          </motion.p>
        </div>

        <motion.div
          ref={ref}
          variants={containerVariants}
          initial="hidden"
          animate={isInView ? 'visible' : 'hidden'}
          className="grid gap-12 md:grid-cols-2"
        >
          {useCases.map(useCase => (
            <motion.div
              key={useCase.id}
              variants={itemVariants}
              className="rounded-xl border border-white/10 bg-white/5 p-6 backdrop-blur-sm hover:bg-white/10 hover:shadow-lg hover:shadow-purple-500/5"
            >
              <div
                className={`mb-4 inline-flex h-12 w-12 items-center justify-center rounded-lg bg-gradient-to-br ${useCase.color} backdrop-blur-md`}
              >
                <useCase.icon className={`h-6 w-6 ${useCase.textColor}`} />
              </div>
              <h3 className={`text-xl font-bold ${useCase.textColor}`}>
                {useCase.title}
              </h3>
              <p className="mt-2 text-white/70">{useCase.description}</p>
            </motion.div>
          ))}
        </motion.div>
      </div>
    </section>
  );
}
