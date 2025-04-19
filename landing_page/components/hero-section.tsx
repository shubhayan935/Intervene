'use client';

import { useRef } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { motion, useScroll, useTransform } from 'framer-motion';
import { ArrowRight, MousePointerClick } from 'lucide-react';

export default function HeroSection() {
  const containerRef = useRef<HTMLDivElement>(null);
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ['start start', 'end start'],
  });

  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  const scale = useTransform(scrollYProgress, [0, 0.5], [1, 0.9]);
  const y = useTransform(scrollYProgress, [0, 0.5], [0, 100]);

  return (
    <div
      ref={containerRef}
      className="relative overflow-hidden py-20 md:py-32 lg:py-40"
    >
      {/* Background gradient */}
      <div className="absolute inset-0 bg-gradient-radial from-purple-900/20 via-black to-black" />

      {/* Animated grid lines */}
      <div className="absolute inset-0 bg-[url('/grid.svg')] bg-center [mask-image:radial-gradient(ellipse_at_center,transparent_20%,black)]" />

      {/* Floating elements */}
      <motion.div
        className="absolute top-1/4 left-1/4 h-40 w-40 rounded-full bg-gradient-to-r from-purple-600/20 to-violet-600/20 blur-3xl"
        animate={{
          x: [0, 30, 0],
          y: [0, -30, 0],
        }}
        transition={{
          duration: 8,
          repeat: Number.POSITIVE_INFINITY,
          repeatType: 'reverse',
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
          repeatType: 'reverse',
        }}
      />

      <div className="container relative px-4 md:px-6">
        <motion.div
          style={{ opacity, scale, y }}
          className="mx-auto max-w-3xl text-center"
        >
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="inline-block rounded-full bg-gradient-to-r from-purple-600/10 to-violet-600/10 px-4 py-1.5 text-sm font-medium text-purple-300 backdrop-blur"
          >
            <span className="mr-2 inline-block h-2 w-2 animate-pulse rounded-full bg-purple-500"></span>
            Introducing Intervene for macOS
          </motion.div>

          <motion.h1
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.1 }}
            className="mt-6 text-4xl font-bold tracking-tight sm:text-5xl md:text-6xl lg:text-7xl"
          >
            <span className="block">Save</span>
            <span className="mt-1 block bg-gradient-to-r from-purple-400 via-violet-400 to-indigo-400 bg-clip-text text-transparent">
              3+ hours per week
            </span>
            <span className="mt-1 block">on repetitive tasks</span>
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            className="mt-6 text-lg text-white/70 md:text-xl"
          >
            Intervene is an on-device autonomous desktop agent that takes over
            repetitive digital workflows — filling forms, renaming files,
            drafting emails, organizing tabs, and more.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.3 }}
            className="mt-8 flex flex-col items-center justify-center gap-4 sm:flex-row"
          >
            <Link
              href="/intervene.zip"
              download
              className="inline-flex h-12 items-center justify-center rounded-md bg-gradient-to-r from-purple-600 to-violet-600 px-8 text-sm font-medium text-white shadow-lg shadow-purple-900/20 transition-all hover:shadow-xl hover:shadow-purple-900/30 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-purple-500"
            >
              Download for macOS
              <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
            <Link
              href="https://www.youtube.com/watch?v=HxsXosrdD0o"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex h-12 items-center justify-center rounded-md border border-white/10 bg-white/5 px-8 text-sm font-medium text-white backdrop-blur transition-colors hover:bg-white/10 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-white/20"
            >
              See how it works
            </Link>
          </motion.div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.4 }}
          style={{ y: useTransform(scrollYProgress, [0, 1], [0, 200]) }}
          className="relative mx-auto mt-16 aspect-video max-w-4xl overflow-hidden rounded-xl border border-white/10 bg-gradient-to-b from-white/5 to-white/0 shadow-2xl"
        >
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="relative h-full w-full">
              <img
                src="/demo.gif"
                alt="Intervene desktop app interface"
                width={1920}
                height={1080}
                className="h-full w-full object-contain"
              />


            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
