"use client"

import { useEffect, useRef } from "react"
import Image from "next/image"
import { motion } from "framer-motion"
import { FileText, FolderOpen, Mail, LayoutGrid, MousePointerClick } from "lucide-react"
import gsap from "gsap"
import { ScrollTrigger } from "gsap/ScrollTrigger"

// Register ScrollTrigger plugin
if (typeof window !== "undefined") {
  gsap.registerPlugin(ScrollTrigger)
}

const useCases = [
  {
    id: "form-filling",
    title: "Form Filling",
    description: "Automatically fill forms with data from various sources.",
    icon: FileText,
    color: "from-violet-500/20 to-purple-500/20",
    textColor: "text-violet-400",
    image: "/placeholder.svg?height=600&width=800",
    position: "right",
  },
  {
    id: "file-organization",
    title: "File Organization",
    description: "Rename, sort, and organize files based on content or metadata.",
    icon: FolderOpen,
    color: "from-pink-500/20 to-rose-500/20",
    textColor: "text-pink-400",
    image: "/placeholder.svg?height=600&width=800",
    position: "left",
  },
  {
    id: "email-management",
    title: "Email Management",
    description: "Draft responses, categorize emails, and manage your inbox.",
    icon: Mail,
    color: "from-cyan-500/20 to-blue-500/20",
    textColor: "text-cyan-400",
    image: "/placeholder.svg?height=600&width=800",
    position: "right",
  },
  {
    id: "tab-organization",
    title: "Tab Organization",
    description: "Group and organize browser tabs based on projects or topics.",
    icon: LayoutGrid,
    color: "from-orange-500/20 to-amber-500/20",
    textColor: "text-orange-400",
    image: "/placeholder.svg?height=600&width=800",
    position: "left",
  },
]

export default function UseCasesSection() {
  const sectionRef = useRef<HTMLDivElement>(null)
  const useCaseRefs = useRef<(HTMLDivElement | null)[]>([])

  useEffect(() => {
    // Skip GSAP initialization during SSR
    if (typeof window === "undefined") return

    const ctx = gsap.context(() => {
      // Create a timeline for each use case
      useCaseRefs.current.forEach((useCase, index) => {
        if (!useCase) return

        // Create a timeline for this use case
        const tl = gsap.timeline({
          scrollTrigger: {
            trigger: useCase,
            start: "top 80%",
            end: "bottom 20%",
            toggleActions: "play none none reverse",
            // markers: true, // For debugging
          },
        })

        // Get the elements within this use case
        const content = useCase.querySelector(".content")
        const image = useCase.querySelector(".image")
        const icon = useCase.querySelector(".icon")
        const title = useCase.querySelector(".title")
        const description = useCase.querySelector(".description")
        const highlight = useCase.querySelector(".highlight")

        // Animate based on position (left or right)
        const isRight = useCases[index].position === "right"

        // Initial state
        gsap.set(content, { opacity: 0, x: isRight ? 50 : -50 })
        gsap.set(image, { opacity: 0, x: isRight ? -50 : 50 })
        gsap.set(icon, { opacity: 0, scale: 0.5 })
        gsap.set(title, { opacity: 0, y: 20 })
        gsap.set(description, { opacity: 0, y: 20 })
        gsap.set(highlight, { width: 0 })

        // Animation sequence
        tl.to(content, { opacity: 1, x: 0, duration: 0.6, ease: "power2.out" })
          .to(image, { opacity: 1, x: 0, duration: 0.6, ease: "power2.out" }, "-=0.4")
          .to(icon, { opacity: 1, scale: 1, duration: 0.4, ease: "back.out(1.7)" }, "-=0.4")
          .to(title, { opacity: 1, y: 0, duration: 0.4, ease: "power2.out" }, "-=0.3")
          .to(description, { opacity: 1, y: 0, duration: 0.4, ease: "power2.out" }, "-=0.2")
          .to(highlight, { width: "100%", duration: 0.6, ease: "power2.inOut" }, "-=0.2")
      })

      // Parallax effect for the floating elements
      const floatingElements = document.querySelectorAll(".floating-element")
      floatingElements.forEach((element) => {
        gsap.to(element, {
          y: "random(-100, 100)",
          scrollTrigger: {
            trigger: sectionRef.current,
            start: "top bottom",
            end: "bottom top",
            scrub: 1,
          },
        })
      })
    }, sectionRef)

    return () => ctx.revert() // Cleanup
  }, [])

  return (
    <section ref={sectionRef} id="use-cases" className="relative py-20 md:py-32 overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-b from-black via-purple-950/10 to-black" />

      {/* Floating elements */}
      <div className="floating-element absolute top-1/4 left-1/4 h-40 w-40 rounded-full bg-gradient-to-r from-purple-600/20 to-violet-600/20 blur-3xl" />
      <div className="floating-element absolute bottom-1/3 right-1/3 h-60 w-60 rounded-full bg-gradient-to-r from-blue-600/20 to-cyan-600/20 blur-3xl" />
      <div className="floating-element absolute top-2/3 right-1/4 h-32 w-32 rounded-full bg-gradient-to-r from-pink-600/20 to-rose-600/20 blur-3xl" />

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
            Fly through your{" "}
            <span className="bg-gradient-to-r from-purple-400 to-violet-400 bg-clip-text text-transparent">
              workflows
            </span>{" "}
            twice as fast
          </motion.h2>
          <motion.p
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.2 }}
            viewport={{ once: true }}
            className="mt-4 text-lg text-white/70"
          >
            Be more responsive to what matters most. Collaborate faster than ever before.
          </motion.p>
        </div>

        <div className="space-y-32 md:space-y-64">
          {useCases.map((useCase, index) => (
            <div
              key={useCase.id}
              ref={(el) => { useCaseRefs.current[index] = el; }}
              className={`relative flex flex-col ${
                useCase.position === "right" ? "md:flex-row" : "md:flex-row-reverse"
              } items-center gap-8 md:gap-12`}
            >
              <div className="content w-full md:w-1/2 space-y-6">
                <div
                  className={`icon relative inline-flex h-16 w-16 items-center justify-center rounded-lg bg-gradient-to-br ${useCase.color} backdrop-blur-md`}
                >
                  <useCase.icon className={`h-8 w-8 ${useCase.textColor}`} />
                </div>

                <h3 className={`title text-2xl md:text-3xl font-bold ${useCase.textColor}`}>{useCase.title}</h3>
                <p className="description text-lg text-white/70">{useCase.description}</p>

                <div className="relative">
                  <div className="highlight absolute bottom-0 left-0 h-1 w-0 bg-gradient-to-r from-purple-500 to-violet-500"></div>
                </div>

                {/* Animated UI elements specific to each use case */}
                {useCase.id === "form-filling" && (
                  <div className="mt-10 flex items-center gap-4">
                    <div className="h-10 w-10 rounded-full bg-white/10 flex items-center justify-center">
                      <MousePointerClick className="h-5 w-5 text-white/70" />
                    </div>
                    <div className="text-sm text-white/70">
                      <span className="font-medium text-white">Auto-fill detected</span> - 12 fields completed
                    </div>
                  </div>
                )}

                {useCase.id === "file-organization" && (
                  <div className="mt-10 flex items-center gap-4">
                    <div className="h-10 w-10 rounded-full bg-white/10 flex items-center justify-center">
                      <FolderOpen className="h-5 w-5 text-white/70" />
                    </div>
                    <div className="text-sm text-white/70">
                      <span className="font-medium text-white">24 files renamed</span> - based on spreadsheet data
                    </div>
                  </div>
                )}

                {useCase.id === "email-management" && (
                  <div className="mt-10 flex items-center gap-4">
                    <div className="h-10 w-10 rounded-full bg-white/10 flex items-center justify-center">
                      <Mail className="h-5 w-5 text-white/70" />
                    </div>
                    <div className="text-sm text-white/70">
                      <span className="font-medium text-white">Response drafted</span> - ready for your review
                    </div>
                  </div>
                )}

                {useCase.id === "tab-organization" && (
                  <div className="mt-10 flex items-center gap-4">
                    <div className="h-10 w-10 rounded-full bg-white/10 flex items-center justify-center">
                      <LayoutGrid className="h-5 w-5 text-white/70" />
                    </div>
                    <div className="text-sm text-white/70">
                      <span className="font-medium text-white">Tabs grouped</span> - by project and relevance
                    </div>
                  </div>
                )}
              </div>

              <div className="image w-full md:w-1/2">
                <div className="relative aspect-video overflow-hidden rounded-xl border border-white/10 bg-black/40 shadow-2xl">
                  <Image
                    src={useCase.image || "/placeholder.svg"}
                    alt={useCase.title}
                    width={800}
                    height={600}
                    className="h-full w-full object-cover"
                  />

                  {/* Animated UI elements overlay */}
                  <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent">
                    {useCase.id === "form-filling" && (
                      <div className="absolute bottom-4 left-4 right-4 rounded-lg border border-white/20 bg-black/50 p-3 backdrop-blur-sm">
                        <div className="flex items-center gap-2">
                          <div className="h-3 w-3 rounded-full bg-green-500"></div>
                          <p className="text-sm font-medium text-white">Form auto-fill complete</p>
                        </div>
                      </div>
                    )}

                    {useCase.id === "file-organization" && (
                      <div className="absolute bottom-4 left-4 right-4 rounded-lg border border-white/20 bg-black/50 p-3 backdrop-blur-sm">
                        <div className="flex items-center gap-2">
                          <div className="h-3 w-3 rounded-full bg-green-500"></div>
                          <p className="text-sm font-medium text-white">Files organized by project</p>
                        </div>
                      </div>
                    )}

                    {useCase.id === "email-management" && (
                      <div className="absolute bottom-4 left-4 right-4 rounded-lg border border-white/20 bg-black/50 p-3 backdrop-blur-sm">
                        <div className="flex items-center gap-2">
                          <div className="h-3 w-3 rounded-full bg-green-500"></div>
                          <p className="text-sm font-medium text-white">Email response generated</p>
                        </div>
                      </div>
                    )}

                    {useCase.id === "tab-organization" && (
                      <div className="absolute bottom-4 left-4 right-4 rounded-lg border border-white/20 bg-black/50 p-3 backdrop-blur-sm">
                        <div className="flex items-center gap-2">
                          <div className="h-3 w-3 rounded-full bg-green-500"></div>
                          <p className="text-sm font-medium text-white">Tabs grouped by project</p>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Floating UI elements */}
        {/* <div className="pointer-events-none absolute top-1/3 left-10 h-20 w-20 rounded-full border border-white/10 bg-white/5 backdrop-blur-md">
          <div className="absolute inset-0 flex items-center justify-center">
            <Search className="h-8 w-8 text-white/50" />
          </div>
        </div>

        <div className="pointer-events-none absolute bottom-1/4 right-10 h-20 w-20 rounded-full border border-white/10 bg-white/5 backdrop-blur-md">
          <div className="absolute inset-0 flex items-center justify-center">
            <Lightbulb className="h-8 w-8 text-white/50" />
          </div>
        </div> */}
      </div>
    </section>
  )
}
