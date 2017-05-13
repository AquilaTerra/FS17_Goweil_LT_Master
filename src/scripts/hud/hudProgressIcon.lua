--
-- HudProgressIcon
--
-- @author  TyKonKet
-- @date 06/04/2017
HudProgressIcon = {};
local HudProgressIcon_mt = Class(HudProgressIcon, Hud);

function HudProgressIcon:new(name, overlayFilename, x, y, width, height, parent, custom_mt)
    if custom_mt == nil then
        custom_mt = HudProgressIcon_mt;
    end
    self.uiScale = g_gameSettings:getValue("uiScale");
    width, height = getNormalizedScreenValues(width * self.uiScale, height * self.uiScale);
    local self = Hud:new(name, x, y, width, height, parent, custom_mt);
    self.filename = overlayFilename;
    self.bgOverlayId = 0;
    self.fgOverlayId = 0;
    if self.filename ~= nil then
        self.bgOverlayId = createImageOverlay(self.filename);
        self.fgOverlayId = createImageOverlay(self.filename);
    end
    self.value = 1;
    return self;
end

function HudProgressIcon:delete(applyToChilds)
    if self.bgOverlayId ~= 0 then
        delete(self.bgOverlayId);
    end
    if self.fgOverlayId ~= 0 then
        delete(self.fgOverlayId);
    end
    HudProgressIcon:superClass().delete(self, applyToChilds);
end

function HudProgressIcon:setColor(r, g, b, a, applyToChilds)
    HudProgressIcon:superClass().setColor(self, r, g, b, a, applyToChilds);
    if self.fgOverlayId ~= 0 then
        setOverlayColor(self.fgOverlayId, self.r, self.g, self.b, self.a);
    end
end

function HudProgressIcon:setUVs(uvs)
    if uvs ~= self.uvs then
        if type(uvs) == "number" then
            printCallstack();
        end
        self.uvs = uvs;
        if self.bgOverlayId ~= 0 then
            setOverlayUVs(self.bgOverlayId, unpack(self.uvs));
        end
        if self.fgOverlayId ~= 0 then
            setOverlayUVs(self.fgOverlayId, unpack(self.uvs));
        end
    end
end

function HudProgressIcon:setValue(newValue)
    if self.value ~= newValue then
        self.value = newValue;
        if self.fgOverlayId ~= 0 then
            local topLeftX = self.uvs[2] + (self.uvs[4] - self.uvs[2]) * self.value;
            local topRightX = self.uvs[6] + (self.uvs[8] - self.uvs[6]) * self.value;
            setOverlayUVs(self.fgOverlayId, self.uvs[1], self.uvs[2], self.uvs[3], topLeftX, self.uvs[5], self.uvs[6], self.uvs[7], topRightX);
        end
    end
end

function HudProgressIcon:render()
    if self.visible then
        local x, y = self:getRenderPosition();
        local w, h = self:getRenderDimension();
        if self.bgOverlayId ~= 0 then
            renderOverlay(self.bgOverlayId, x, y, w, h);
        end
        if self.fgOverlayId ~= 0 then
            renderOverlay(self.fgOverlayId, x, y, w, h * self.value);
        end
    end
end