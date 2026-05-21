import React from "react";
import { GraduationCap, Zap, MessageSquare, TrendingUp, ArrowRight, Star, Clock, Award } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export default function Home() {
  return (
    <div>
      {/* Hero Section - Unique Design */}
      <section className="relative overflow-hidden border-b bg-gradient-to-br from-indigo-50 via-background to-purple-50">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,hsl(243_75%_59%/0.12),transparent 60%)]" />
        <div className="relative mx-auto max-w-7xl px-4 py-32 sm:px-6 lg:px-8">
          <div className="grid lg:grid-cols-2 gap-12 items-center">
            <div className="text-center lg:text-left">
              <Badge variant="outline" className="mb-6 gap-2 px-5 py-2.5 text-base bg-indigo-50 text-indigo-800 border-indigo-200 animate-fade-in">
                <Zap className="h-4 w-4 text-indigo-600" />
                Nouvelle Plateforme 2026
              </Badge>
              <h1 className="text-4xl font-extrabold tracking-tight sm:text-5xl lg:text-6xl animate-fade-in-up">
                Apprenez, Progressez,{" "}
                <span className="bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">
                  Excellez
                </span>
              </h1>
              <p className="mt-7 text-lg leading-8 text-slate-600 sm:text-xl animate-fade-in-up stagger-2">
                Accédez à des cours de qualité, un tuteur IA personnalisé, et suivez votre progression en temps réel.
              </p>
              <div className="mt-10 flex flex-col items-center lg:items-start justify-center gap-4 sm:flex-row animate-fade-in-up stagger-3">
                <Button size="lg" className="gap-2 text-base bg-indigo-600 hover:bg-indigo-700 shadow-lg shadow-indigo-500/25 transition-all hover:shadow-xl hover:shadow-indigo-500/35" asChild>
                  <a href="/courses">
                    Explorer les cours
                    <ArrowRight className="h-4 w-4" />
                  </a>
                </Button>
                <Button variant="outline" size="lg" className="gap-2 text-base border-2 border-indigo-200 text-indigo-700 hover:bg-indigo-50 transition-all" asChild>
                  <a href="/auth/login">
                    Se connecter
                  </a>
                </Button>
              </div>
            </div>
            <div className="relative animate-fade-in-up stagger-3">
              <div className="absolute -inset-4 bg-gradient-to-tr from-indigo-200/40 to-purple-200/40 rounded-3xl blur-2xl" />
              <Card className="relative overflow-hidden border-0 bg-white shadow-2xl shadow-indigo-100/60">
                <CardContent className="p-8">
                  <div className="grid grid-cols-2 gap-6">
                    <div className="space-y-3">
                      <div className="flex items-center gap-3">
                        <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-indigo-100">
                          <GraduationCap className="h-6 w-6 text-indigo-600" />
                        </div>
                        <div>
                          <p className="text-2xl font-bold text-slate-800">+1200</p>
                          <p className="text-sm text-slate-500">Cours</p>
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-purple-100">
                          <MessageSquare className="h-6 w-6 text-purple-600" />
                        </div>
                        <div>
                          <p className="text-2xl font-bold text-slate-800">24/7</p>
                          <p className="text-sm text-slate-500">Tuteur IA</p>
                        </div>
                      </div>
                    </div>
                    <div className="space-y-3">
                      <div className="flex items-center gap-3">
                        <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-emerald-100">
                          <TrendingUp className="h-6 w-6 text-emerald-600" />
                        </div>
                        <div>
                          <p className="text-2xl font-bold text-slate-800">+15K</p>
                          <p className="text-sm text-slate-500">Étudiants</p>
                        </div>
                      </div>
                      <div className="flex items-center gap-3">
                        <div className="flex h-12 w-12 items-center justify-center rounded-2xl bg-amber-100">
                          <Star className="h-6 w-6 text-amber-600" />
                        </div>
                        <div>
                          <p className="text-2xl font-bold text-slate-800">4.9★</p>
                          <p className="text-sm text-slate-500">Note moyenne</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </section>

      {/* Features Grid - New Layout */}
      <section className="mx-auto max-w-7xl px-4 py-24 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-3xl text-center mb-16">
          <Badge variant="outline" className="mb-4 border-indigo-200 text-indigo-800 bg-indigo-50">Fonctionnalités</Badge>
          <h2 className="text-3xl font-bold tracking-tight sm:text-4xl text-slate-900">
            Pourquoi choisir notre plateforme ?
          </h2>
        </div>
        <div className="mx-auto mt-12 grid max-w-6xl grid-cols-1 gap-8 md:grid-cols-3">
          <FeatureCard
            icon={<GraduationCap className="h-7 w-7" />}
            title="Cours Premium"
            description="Apprenez avec des contenus structurés, des vidéos HD et des exercices pratiques."
            color="from-indigo-500 to-indigo-600"
            bg="bg-indigo-50"
          />
          <FeatureCard
            icon={<MessageSquare className="h-7 w-7" />}
            title="Tuteur IA"
            description="Posez vos questions à tout moment et recevez des réponses personnalisées instantanément."
            color="from-purple-500 to-purple-600"
            bg="bg-purple-50"
          />
          <FeatureCard
            icon={<TrendingUp className="h-7 w-7" />}
            title="Suivi Pro"
            description="Analysez votre progression, identifiez vos forces et améliorez continuellement."
            color="from-emerald-500 to-emerald-600"
            bg="bg-emerald-50"
          />
        </div>
      </section>

      {/* Highlights Section */}
      <section className="border-y bg-gradient-to-r from-slate-50 via-indigo-50/50 to-slate-50">
        <div className="mx-auto max-w-5xl grid grid-cols-2 md:grid-cols-4 gap-8 px-4 py-16 sm:px-6 lg:px-8">
          {[
            { icon: <Clock className="h-6 w-6" />, value: "100%", label: "En ligne", color: "text-indigo-600" },
            { icon: <Award className="h-6 w-6" />, value: "Certifié", label: "Diplômes", color: "text-purple-600" },
            { icon: <Zap className="h-6 w-6" />, value: "Rapide", label: "Apprentissage", color: "text-emerald-600" },
            { icon: <Star className="h-6 w-6" />, value: "Premium", label: "Qualité", color: "text-amber-600" },
          ].map((item, i) => (
            <div key={i} className="text-center animate-fade-in-up" style={{ animationDelay: `${i * 0.1}s` }}>
              <div className={`inline-flex items-center justify-center p-3 rounded-2xl bg-white shadow-sm mb-3 ${item.color}`}>
                {item.icon}
              </div>
              <div className={`text-3xl font-extrabold ${item.color}`}>{item.value}</div>
              <div className="mt-1 text-sm font-medium text-slate-600">{item.label}</div>
            </div>
          ))}
        </div>
      </section>

      {/* CTA Section - New Design */}
      <section className="mx-auto max-w-7xl px-4 py-24 sm:px-6 lg:px-8">
        <Card className="overflow-hidden border-0 bg-gradient-to-br from-indigo-600 via-purple-600 to-indigo-700 text-white shadow-2xl shadow-indigo-500/30">
          <CardContent className="flex flex-col items-center p-12 text-center sm:p-16">
            <div className="mb-6 flex h-20 w-20 items-center justify-center rounded-3xl bg-white/20 backdrop-blur-xl">
              <Award className="h-10 w-10" />
            </div>
            <h2 className="text-3xl font-bold sm:text-4xl">Prêt à commencer votre aventure ?</h2>
            <p className="mt-5 max-w-2xl text-lg text-white/85">
              Rejoignez des milliers d'étudiants et développez vos compétences aujourd'hui. L'inscription est gratuite !
            </p>
            <div className="mt-10 flex flex-col sm:flex-row gap-4">
              <Button size="lg" variant="secondary" className="text-base font-semibold bg-white text-indigo-700 hover:bg-slate-100 shadow-xl transition-all hover:-translate-y-1" asChild>
                <a href="/auth/register">
                  Créer un compte gratuit
                  <ArrowRight className="h-4 w-4 ml-2" />
                </a>
              </Button>
              <Button size="lg" variant="outline" className="text-base font-semibold border-2 border-white/30 bg-transparent hover:bg-white/10 text-white" asChild>
                <a href="/courses">
                  Voir les cours
                </a>
              </Button>
            </div>
          </CardContent>
        </Card>
      </section>
    </div>
  );
}

function FeatureCard({
  icon,
  title,
  description,
  color,
  bg,
}: {
  icon: React.ReactNode;
  title: string;
  description: string;
  color: string;
  bg: string;
}) {
  return (
    <Card className="group relative overflow-hidden transition-all duration-400 hover:shadow-xl hover:-translate-y-2 border-slate-200 animate-fade-in-up">
      <CardContent className="p-8">
        <div className={`mb-5 inline-flex rounded-2xl ${bg} p-4 text-slate-700 transition-all duration-300 group-hover:bg-gradient-to-br group-hover:${color} group-hover:text-white group-hover:shadow-lg`}>
          {icon}
        </div>
        <h3 className="mb-3 text-xl font-bold text-slate-800">{title}</h3>
        <p className="text-base leading-relaxed text-slate-600">{description}</p>
      </CardContent>
      <div className={`absolute inset-x-0 bottom-0 h-1.5 scale-x-0 bg-gradient-to-r ${color} transition-transform duration-400 group-hover:scale-x-100`} />
    </Card>
  );
}
