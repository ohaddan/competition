function [all_schedule_colors, COLORS_BY_MODEL] = COMPETITION_schedule_colors()
%COMPETITION_SCHEDULE_COLORS Summary of this function goes here
%   Detailed explanation goes here
COLORS_BY_MODEL = struct;
COLORS_BY_MODEL.ql.het.competition = [0 0.4470 0.7410];
COLORS_BY_MODEL.ql.het.online = COLORS_BY_MODEL.ql.het.competition;

COLORS_BY_MODEL.ql.het.literature = [0.5 0.3 0.6];
COLORS_BY_MODEL.ql.het.lab = COLORS_BY_MODEL.ql.het.literature;

COLORS_BY_MODEL.ql.hom.competition = COLORS_BY_MODEL.ql.het.competition * 1.3;
COLORS_BY_MODEL.ql.hom.online = COLORS_BY_MODEL.ql.hom.competition;

COLORS_BY_MODEL.ql.hom.literature = COLORS_BY_MODEL.ql.het.literature *1.5;
COLORS_BY_MODEL.ql.hom.lab = COLORS_BY_MODEL.ql.hom.literature;

COLORS_BY_MODEL.catie= [0.9290 0.7 0.3];
COLORS_BY_MODEL.natural_color = [170 210 180]./255;



all_schedule_colors(1,:) = COLORS_BY_MODEL.catie;
all_schedule_colors(2,:) = COLORS_BY_MODEL.natural_color*0.9;
all_schedule_colors(3,:) = COLORS_BY_MODEL.natural_color*0.8;
all_schedule_colors(4,:) = COLORS_BY_MODEL.natural_color*0.7;
all_schedule_colors(5,:) = COLORS_BY_MODEL.natural_color*0.6;
all_schedule_colors(6,:) = COLORS_BY_MODEL.ql.het.competition;
all_schedule_colors(7,:) = COLORS_BY_MODEL.ql.hom.literature;
all_schedule_colors(8,:) = COLORS_BY_MODEL.natural_color*0.5;
all_schedule_colors(9,:) = COLORS_BY_MODEL.ql.hom.competition;
all_schedule_colors(10,:) = COLORS_BY_MODEL.ql.het.literature;
all_schedule_colors(11,:) = COLORS_BY_MODEL.natural_color*0.4;
end

